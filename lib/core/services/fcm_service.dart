import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/services/audio_service/audio_service.dart';
import 'package:web_admin_san/core/services/browser_notification.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/feature/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import 'package:web_admin_san/feature/notifications/data/model/receive_message_notification_model/receive_message_notification_model.dart';
import 'package:web_admin_san/feature/notifications/presentation/module/notification_module/notification_module.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/admin_chat_model.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/chat_events/chat_events.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/car_approval/view_model/car_approval_cubit.dart';
import 'web_interop/web_interop.dart' as web_interop;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    debugPrint('FCM Admin: Handling background message: ${message.messageId}');
  }
}

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  final Set<String> _recentlyProcessedMessageKeys = <String>{};

  static bool get isSupported {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      default:
        return false;
    }
  }

  /// Checks if a given token string is a dummy fallback token or empty.
  static bool isDummyToken(String? token) {
    if (token == null) return true;
    final t = token.trim();
    if (t.isEmpty) return true;
    return t.startsWith('fcm_web_') ||
        t.startsWith('fcm_windows_') ||
        t.startsWith('fcm_linux_') ||
        t.startsWith('fcm_macos_') ||
        t.startsWith('fcm_android_') ||
        t.startsWith('fcm_ios_') ||
        (t.startsWith('fcm_') && t.length < 50);
  }

  Future<void> init() async {
    if (!isSupported) {
      if (kDebugMode) {
        debugPrint('FCM Admin: Platform not supported. Skipping init.');
      }
      return;
    }

    if (_isInitialized) return;

    final messaging = FirebaseMessaging.instance;

    // Stage 1: Always register message listeners FIRST so no notification is missed
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint('FCM Admin: Foreground message received: ${message.data}');
        }
        _handleRemoteMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          debugPrint('FCM Admin: Message opened app: ${message.data}');
        }
        _processMessagePayload(
          message.data,
          notifTitle: message.notification?.title,
          notifBody: message.notification?.body,
          isClick: true,
          isBackgroundOnly: false,
          triggerSound: true,
          showBrowserNotif: false,
        );
      });

      // Register Web Service Worker interop listeners for background cross-tab messages and clicks
      if (kIsWeb) {
        try {
          web_interop.listenToWebMessages(
            onNotificationClick: (data) {
              if (kDebugMode) {
                debugPrint(
                    'FCM Admin: Web notification clicked with payload: $data');
              }
              handleWebNotificationClick(data);
            },
            onBackgroundMessage: (data) {
              if (kDebugMode) {
                debugPrint(
                    'FCM Admin: Web background message received via service worker: $data');
              }
              handleWebBackgroundMessage(data);
            },
          );
        } catch (webErr) {
          if (kDebugMode) {
            debugPrint(
                'FCM Admin: Error registering web message listener: $webErr');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FCM Admin: Error registering message listeners: $e');
      }
    }

    // Stage 2: Request user permission for notifications
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        debugPrint(
            'FCM Admin: Authorization status: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FCM Admin: Permission request note: $e');
      }
    }

    // Stage 3: Fetch FCM Token and sync with backend if legitimate
    try {
      _fcmToken = await getToken(vapidKey: FcmConfig.webVapidKey);
      if (_fcmToken != null &&
          _fcmToken!.isNotEmpty &&
          !isDummyToken(_fcmToken)) {
        await _syncTokenIfUserAvailable(_fcmToken!);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FCM Admin: Initial token fetch note: $e');
      }
    }

    // Stage 4: Listen to token refresh
    try {
      messaging.onTokenRefresh.listen((newToken) {
        if (newToken.isNotEmpty && !isDummyToken(newToken)) {
          _fcmToken = newToken;
          _syncTokenIfUserAvailable(newToken);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FCM Admin: Token refresh listener note: $e');
      }
    }

    _isInitialized = true;
  }

  Future<String>? _pendingGetToken;

  Future<String> getToken({String? vapidKey}) async {
    if (_pendingGetToken != null) return _pendingGetToken!;
    _pendingGetToken = _internalGetToken(vapidKey: vapidKey);
    try {
      return await _pendingGetToken!;
    } finally {
      _pendingGetToken = null;
    }
  }

  Future<String> _internalGetToken({String? vapidKey}) async {
    // 0. Clean up any stored dummy token from local storage
    try {
      final saved = await AuthLocalStorage.getFcmToken();
      if (isDummyToken(saved)) {
        await AuthLocalStorage.deleteFcmToken();
      }
    } catch (_) {}

    if (isDummyToken(_fcmToken)) {
      _fcmToken = null;
    }

    // 1. Attempt to fetch real token from Firebase if supported
    if (isSupported) {
      try {
        final effectiveVapidKey =
            (vapidKey != null && vapidKey.trim().isNotEmpty)
                ? vapidKey.trim()
                : FcmConfig.webVapidKey.trim();

        if (kIsWeb) {
          try {
            final settings =
                await FirebaseMessaging.instance.getNotificationSettings();
            if (settings.authorizationStatus ==
                AuthorizationStatus.notDetermined) {
              await FirebaseMessaging.instance.requestPermission();
            }
          } catch (e) {
            if (kDebugMode) debugPrint('FCM Web: Permission check note: $e');
          }
        }

        final token = await FirebaseMessaging.instance
            .getToken(
              vapidKey: (kIsWeb && effectiveVapidKey.isNotEmpty)
                  ? effectiveVapidKey
                  : null,
            )
            .timeout(
              const Duration(seconds: 15),
              onTimeout: () => null,
            );

        if (token != null && token.trim().isNotEmpty && !isDummyToken(token)) {
          _fcmToken = token.trim();
          await AuthLocalStorage.saveFcmToken(_fcmToken!);
          return _fcmToken!;
        }
      } catch (e) {
        if (kDebugMode) debugPrint('FCM Admin getToken note: $e');
      }
    }

    // 2. Return cached memory token if valid and not dummy
    if (_fcmToken != null &&
        _fcmToken!.trim().isNotEmpty &&
        !isDummyToken(_fcmToken)) {
      return _fcmToken!;
    }

    // 3. Return locally stored FCM token if valid and not dummy
    final savedToken = await AuthLocalStorage.getFcmToken();
    if (savedToken != null &&
        savedToken.trim().isNotEmpty &&
        !isDummyToken(savedToken)) {
      _fcmToken = savedToken.trim();
      return _fcmToken!;
    }

    // 4. On web, if real token is not yet available, return empty string instead of fake dummy token
    if (kIsWeb) {
      if (kDebugMode) {
        debugPrint(
            'FCM Admin Web: Real token not yet available, returning empty.');
      }
      return '';
    }

    // 5. Fallback only for non-web environments (test harnesses / desktop)
    final fallbackToken = await _getOrCreateFallbackToken();
    _fcmToken = fallbackToken;
    return fallbackToken;
  }

  Future<String> _getOrCreateFallbackToken() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = (Random().nextInt(900000) + 100000).toString();
    final platformTag =
        kIsWeb ? 'web' : defaultTargetPlatform.name.toLowerCase();
    final generated = 'fcm_${platformTag}_${timestamp}_$randomSuffix';
    await AuthLocalStorage.saveFcmToken(generated);
    return generated;
  }

  Future<void> syncCurrentToken({int? userId, int? userType}) async {
    final user = await AuthLocalStorage.getUser();
    final effectiveUserId = userId ?? user?.userid;
    // تخصيص الأدمن: UserType.adminUser (6)
    final effectiveUserType = userType ?? user?.type ?? UserType.adminUser;

    if (effectiveUserId != null && effectiveUserId > 0) {
      final token = await getToken(vapidKey: FcmConfig.webVapidKey);
      if (token.isNotEmpty && !isDummyToken(token)) {
        await _syncTokenWithBackend(
          userId: effectiveUserId,
          userType: effectiveUserType,
          token: token,
        );
      }
    }
  }

  Future<void> _syncTokenIfUserAvailable(String token) async {
    if (token.trim().isEmpty || isDummyToken(token)) return;
    final user = await AuthLocalStorage.getUser();
    if (user != null && user.userid != null && user.userid! > 0) {
      await _syncTokenWithBackend(
        userId: user.userid!,
        userType: user.type ?? UserType.adminUser,
        token: token,
      );
    }
  }

  Future<void> _syncTokenWithBackend({
    required int userId,
    required int userType,
    required String token,
  }) async {
    final cleanToken = token.trim();
    if (cleanToken.isEmpty || isDummyToken(cleanToken)) {
      if (kDebugMode) {
        debugPrint(
            'FCM: Skipping backend sync for empty/dummy token: $cleanToken');
      }
      return;
    }

    try {
      final payload = {
        'USERID': userId,
        'USERTYPE': userType,
        'FCMTOKEN': cleanToken,
      };

      final response = await Network.postDataWithBodyAndParams(
        payload,
        {'lang': 'ar'},
        ApiLink.updateFcmToken,
      );

      if (kDebugMode) {
        debugPrint(
            'FCM: UpdateFcmToken response status: ${response.statusCode}, data: ${response.data}');
      }

      await AuthLocalStorage.saveFcmToken(cleanToken);

      if (kDebugMode) {
        debugPrint(
            'FCM: Successfully synced token with backend for Admin $userId (type $userType)');
      }

      // اشتراك الأدمن في التوبيك admin و all
      if (isSupported && !cleanToken.startsWith('fcm_')) {
        await subscribeToTopic(NotificationTopic.admin, userType: userType);
        await subscribeToTopic('all', userType: userType);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('FCM Admin sync error: $e');
    }
  }

  Future<void> subscribeToTopic(String topic, {int? userType}) async {
    final token = _fcmToken ?? await AuthLocalStorage.getFcmToken();
    if (token == null || token.isEmpty || isDummyToken(token)) return;

    if (!kIsWeb) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      } catch (_) {}
    }

    try {
      final body = jsonEncode({
        'fcmToken': token,
        'topic': topic,
        if (userType != null) 'userType': userType,
      });
      await Network.postDataWithBody(body, ApiLink.subscribeToTopic);
    } catch (_) {}
  }

  void _handleRemoteMessage(RemoteMessage message) {
    _processMessagePayload(
      message.data,
      notifTitle: message.notification?.title,
      notifBody: message.notification?.body,
      isClick: false,
      isBackgroundOnly: false,
      triggerSound: true,
      showBrowserNotif: true,
    );
  }

  /// Handles background messages broadcasted by firebase-messaging-sw.js
  /// when the dashboard is open in an inactive/background browser tab.
  void handleWebBackgroundMessage(Map<String, dynamic> data,
      {String? title, String? body}) {
    _processMessagePayload(
      data,
      notifTitle: title,
      notifBody: body,
      isClick: false,
      isBackgroundOnly: true,
      triggerSound: true,
      showBrowserNotif: false,
    );
  }

  /// Handles notification click events from firebase-messaging-sw.js
  /// when the user clicks the browser notification to focus the tab.
  void handleWebNotificationClick(Map<String, dynamic> data,
      {String? title, String? body}) {
    _processMessagePayload(
      data,
      notifTitle: title,
      notifBody: body,
      isClick: true,
      isBackgroundOnly: false,
      triggerSound: true,
      showBrowserNotif: false,
    );
  }

  void _processMessagePayload(
    Map<String, dynamic> rawData, {
    String? notifTitle,
    String? notifBody,
    bool isClick = false,
    bool isBackgroundOnly = false,
    bool triggerSound = true,
    bool showBrowserNotif = true,
  }) {
    try {
      final data = Map<String, dynamic>.from(rawData);
      final rawType =
          (data['type'] ?? data['eventType'] ?? data['event_type'] ?? '')
              .toString();
      final normType =
          rawType.toLowerCase().replaceAll('_', '').replaceAll('-', '').trim();

      final title = notifTitle ??
          data['title'] ??
          data['latintitle'] ??
          data['ar_title'] ??
          data['en_title'] ??
          data['fromusername'] ??
          data['sender'] ??
          LocaleKeys.newAdminNotification.tr();
      final body = notifBody ??
          data['body'] ??
          data['description'] ??
          data['latindesc'] ??
          data['ar_body'] ??
          data['en_body'] ??
          data['message'] ??
          data['text'] ??
          '';

      // Deduplication: prevent dual execution between Foreground stream and ServiceWorker postMessage
      final messageId = data['messageId'] ??
          data['google.message_id'] ??
          data['notificationId'] ??
          data['notificationid'] ??
          data['id'] ??
          '${normType}_${title}_${body}_${data['orderId'] ?? data['orderid'] ?? data['fromuser']}';
      final dedupKey = '${messageId}_$isClick';
      if (_recentlyProcessedMessageKeys.contains(dedupKey)) {
        if (kDebugMode) {
          debugPrint(
              'FCM Admin: Suppressing duplicate message delivery: $dedupKey');
        }
        return;
      }
      _recentlyProcessedMessageKeys.add(dedupKey);
      Future.delayed(const Duration(seconds: 15), () {
        _recentlyProcessedMessageKeys.remove(dedupKey);
      });

      if (showBrowserNotif) {
        showBrowserNotification(title.toString(), body.toString());
      }

      final adaptedPayload = <String, dynamic>{
        'type': rawType,
        'title': title.toString(),
        'body': body.toString(),
        'data': data,
        ...data,
      };

      final isOpenCloseChatPayload = normType == 'openclosechat';
      final isSupportTicketPayload = normType == 'supportticket';

      final isChatPayload = normType == 'chat' ||
          normType == 'receivemessage' ||
          isSupportTicketPayload ||
          data.containsKey('fromuser') ||
          data.containsKey('fromUser') ||
          data.containsKey('fromUserId') ||
          (data.containsKey('message') &&
              (data.containsKey('sender') || data.containsKey('fromusername')));

      final isNewOrderPayload = normType == 'neworder' ||
          data.containsKey('orderinfo') ||
          data.containsKey('orderInfo');

      final isUpdateOrderStatusPayload =
          normType == 'updateorderstatus' || normType == 'orderstatus';

      final isCarApprovalPayload = normType == 'carapproval' ||
          normType == 'carapproved' ||
          normType == 'carrejected' ||
          data['type'] == 'car_approval' ||
          data['eventType'] == 'car_approval' ||
          data['type'] == 'car_approved' ||
          data['type'] == 'car_rejected';

      // 1. Play differentiated sound alerts
      if (triggerSound) {
        if (isNewOrderPayload) {
          AudioService.instance.startNotificationSound();
        } else {
          AudioService.instance.playChime();
        }
      }

      // 2. Dispatch to domain handlers
      if (isNewOrderPayload) {
        NotificationModule.instance.newOrderHandler.handle([adaptedPayload]);
      } else if (isUpdateOrderStatusPayload) {
        NotificationModule.instance.updateOrderStatusHandler
            .handle([adaptedPayload]);
        NotificationModule.instance.receiveNotificationHandler
            .handle([adaptedPayload]);
      } else if (isCarApprovalPayload) {
        final reqId = int.tryParse(data['requestId']?.toString() ??
            data['requestid']?.toString() ??
            data['id']?.toString() ??
            '') ?? 0;

        if (isClick) {
          try {
            getIt<AppCubit>().navigateToPage(PagesOfAllApp.carApprovalsNumber);
            if (reqId > 0) {
              Future.delayed(const Duration(milliseconds: 300), () {
                try {
                  getIt<CarApprovalCubit>().loadRequestDetails(reqId);
                } catch (_) {}
              });
            }
          } catch (_) {}
        } else {
          try {
            getIt<CarApprovalCubit>().onIncomingCarApprovalNotification(
              requestId: reqId,
              autoOpen: false,
            );
          } catch (_) {}
        }

        // Add to NotificationCubit so bell updates instantly
        try {
          final rawNotifId = data['notificationId'] ??
              data['notificationid'] ??
              data['notification_id'] ??
              data['id'];
          final notifModel = NotificationModel(
            id: int.tryParse(rawNotifId?.toString() ?? ''),
            title: title.toString(),
            description: body.toString(),
            latinTitle: title.toString(),
            latinDesc: body.toString(),
            isViewed: false,
            date: DateTime.now(),
          );
          getIt<NotificationCubit>().addNotification(notifModel);
        } catch (_) {}
      } else if (isOpenCloseChatPayload) {
        try {
          getIt<AdminChatCubit>().onOpenCloseChatEvent(data);
        } catch (_) {}
      } else if (isChatPayload) {
        final fromUserRaw = data['fromUser'] ??
            data['fromuser'] ??
            data['fromUserId'] ??
            data['from_user'] ??
            data['from_user_id'] ??
            data['FROMUSER'] ??
            data['senderId'] ??
            data['sender_id'];
        final fromId = int.tryParse(fromUserRaw?.toString() ?? '') ?? 0;

        final fromTypeRaw = data['fromUserType'] ??
            data['fromusertype'] ??
            data['from_user_type'] ??
            data['FROMUSERTYPE'];
        final fromType = int.tryParse(fromTypeRaw?.toString() ?? '') ?? 1;

        final toUserRaw = data['toUser'] ??
            data['touser'] ??
            data['toUserId'] ??
            data['to_user'] ??
            data['TOUSER'];
        final toId = int.tryParse(toUserRaw?.toString() ?? '') ?? 0;

        final toTypeRaw = data['toUserType'] ??
            data['tousertype'] ??
            data['to_user_type'] ??
            data['TOUSERTYPE'];
        final toType = int.tryParse(toTypeRaw?.toString() ?? '') ?? 6;

        final messageText =
            body.isNotEmpty ? body : (data['message']?.toString() ?? '');
        final senderName = (data['fromUserName'] ??
                data['fromusername'] ??
                data['FROMUSERNAME'] ??
                data['sender'] ??
                title)
            .toString();

        final receiveMsgData = ReceiveMessageData(
          id: data['id']?.toString() ?? '0',
          fromUser: fromId.toString(),
          fromUserType: fromType.toString(),
          toUser: toId.toString(),
          toUserType: toType.toString(),
          message: messageText,
          fromUserName: senderName,
          date: data['date']?.toString() ?? DateTime.now().toIso8601String(),
          viewed: '0',
          isClosed: '0',
          orderId: data['orderId']?.toString() ?? data['orderid']?.toString(),
        );

        final chatMsgModel = ChatMessageModel(
          id: int.tryParse(data['id']?.toString() ?? '') ?? 0,
          fromUser: fromId,
          fromUserType: fromType,
          toUser: toId,
          toUserType: toType,
          message: messageText,
          date: DateTime.now(),
          viewed: false,
          isClosed: false,
          orderId: int.tryParse(
              data['orderId']?.toString() ?? data['orderid']?.toString() ?? ''),
          fromUserName: senderName,
        );

        // Broadcast to live stream
        ChatEvents.instance.add(receiveMsgData);

        // Deliver immediately to AdminChatCubit (creates ticket if new, updates active thread if selected)
        try {
          getIt<AdminChatCubit>().onIncomingMessage(chatMsgModel);
        } catch (_) {}

        // Add to NotificationCubit so bell updates instantly
        try {
          final rawNotifId = data['notificationId'] ??
              data['notificationid'] ??
              data['notification_id'] ??
              data['id'];
          final notifModel = NotificationModel(
            id: int.tryParse(rawNotifId?.toString() ?? ''),
            title: senderName.isNotEmpty ? senderName : LocaleKeys.newTechnicalSupportMessage.tr(),
            description: messageText,
            latinTitle:
                senderName.isNotEmpty ? senderName : 'New Support Message',
            latinDesc: messageText,
            fromUserId: fromId,
            fromUserType: fromType,
            toUserId: toId,
            toUserType: toType,
            isViewed: false,
            date: DateTime.now(),
          );
          getIt<NotificationCubit>().addNotification(notifModel);
        } catch (_) {}

        NotificationModule.instance.receiveMessageHandler
            .handle([adaptedPayload]);
      } else {
        // General admin notification (not chat, not order)
        try {
          final rawNotifId = data['notificationId'] ??
              data['notificationid'] ??
              data['notification_id'] ??
              data['id'];
          final notifModel = NotificationModel(
            id: int.tryParse(rawNotifId?.toString() ?? ''),
            title: title.toString(),
            description: body.toString(),
            latinTitle: title.toString(),
            latinDesc: body.toString(),
            isViewed: false,
            date: DateTime.now(),
          );
          getIt<NotificationCubit>().addNotification(notifModel);
        } catch (_) {}

        NotificationModule.instance.receiveNotificationHandler
            .handle([adaptedPayload]);
      }

      // 3. Instant refresh for notification bell counter and chat tickets from backend
      if (!isChatPayload) {
        try {
          getIt<NotificationCubit>().getUserNotification();
        } catch (_) {}
      }
      try {
        getIt<AdminChatCubit>().fetchSupportTickets(silent: true);
      } catch (_) {}
    } catch (e, stack) {
      if (kDebugMode) debugPrint('FCM Admin processing error: $e\n$stack');
    }
  }

  Future<void> disconnect() async {
    _isInitialized = false;
    _fcmToken = null;
    await AuthLocalStorage.deleteFcmToken();
  }
}
