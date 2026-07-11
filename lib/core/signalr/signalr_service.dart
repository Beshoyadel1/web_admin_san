import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import '../../../../../../core/audio_service/audio_service.dart';
import '../../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../features/notifications/presentation/pages/notification_dialog/notification_dialog.dart';
import '../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../../../main.dart';

class SignalRService {
  SignalRService._();

  static final SignalRService instance = SignalRService._();

  HubConnection? _hubConnection;

  bool _isNotificationDialogShowing = false;

  HubConnection? get connection => _hubConnection;

  bool get isConnected => _hubConnection?.state == HubConnectionState.connected;

  Map<String, dynamic>? _getRoot(
    List<Object?>? arguments,
  ) {
    if (arguments == null || arguments.isEmpty) {
      return null;
    }

    final first = arguments.first;

    if (first is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(
      first as Map<dynamic, dynamic>,
    );
  }

  Future<void> connect({
    required String hubUrl,
  }) async {
    if (isConnected) {
      debugPrint("✅ SignalR Already Connected");
      return;
    }

    await disconnect();

    try {
      _hubConnection = HubConnectionBuilder()
          .withAutomaticReconnect([
            10000,
            15000,
            20000,
            30000,
            60000,
            180000,
          ])
          .withUrl(
            hubUrl,
            HttpConnectionOptions(
              transport: HttpTransportType.longPolling,
              logging: (level, message) {
// debugPrint(message);
              },
            ),
          )
          .build();

      ///===================== Connection =====================

      _hubConnection!.onclose((error) async {
        debugPrint("SignalR Closed => $error");

        await Future.delayed(const Duration(seconds: 3));

        if (!isConnected) {
          await connect(hubUrl: hubUrl);
        }
      });

      _hubConnection!.onreconnected((connectionId) {
        debugPrint("🟢 SignalR Reconnected");
        debugPrint("ConnectionId => $connectionId");
      });

      ///===================== Events =====================

      _hubConnection!.on(
        SignalRTypes.receiveNotification,
        (arguments) => _handleReceiveNotification(arguments),
      );

      _hubConnection!.on(
        SignalRTypes.receiveMessage,
        (arguments) => _handleReceiveMessage(arguments),
      );

      _hubConnection!.on(
        SignalRTypes.newOrder,
        (arguments) => _handleNewOrder(arguments),
      );

      _hubConnection!.on(
        SignalRTypes.updateOrderStatus,
        (arguments) => _handleUpdateOrderStatus(arguments),
      );

      _hubConnection!.on(
        SignalRTypes.newServiceRequest,
        (arguments) => _handleNewServiceRequest(arguments),
      );

      _hubConnection!.on(
        SignalRTypes.newServiceOffer,
        (arguments) => _handleNewServiceOffer(arguments),
      );

      _hubConnection!.on(
        SignalRTypes.transferCarOwnership,
        (arguments) => _handleTransferCarOwnership(arguments),
      );

      _hubConnection!.on(
        SignalRTypes.openCloseChat,
        (arguments) => _handleOpenCloseChat(arguments),
      );

      await _hubConnection!.start();

      debugPrint("✅ SignalR Connected");
    } catch (e, s) {
      debugPrint("SignalR Error => $e");
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await _hubConnection?.stop();
    } catch (_) {}

    _hubConnection = null;
  }

//==========================================================
// Notification Handler
//==========================================================

  Future<void> _handleReceiveNotification(
    List<Object?>? arguments,
  ) async {
    try {
      if (arguments == null || arguments.isEmpty) {
        return;
      }

      final currentUser = await AuthLocalStorage.getUser();

      if (currentUser == null) {
        return;
      }

      if (arguments.first is! Map) {
        debugPrint("ReceiveNotification: invalid arguments");
        return;
      }

      final root = Map<String, dynamic>.from(
        arguments.first as Map<dynamic, dynamic>,
      );
      final int? userId = root["userId"];
      final int? userType = root["userType"];

      if (userType != currentUser.type) {
        return;
      }

      if (userId != null && userId != 0 && userId != currentUser.userid) {
        return;
      }

      final notification = Map<String, dynamic>.from(root["data"]);

      final data = Map<String, dynamic>.from(notification["data"]);

      final notificationJson = jsonDecode(
        data["notification"] as String,
      ) as Map<String, dynamic>;

      final model = NotificationModel.fromJson(
        notificationJson,
      );

      await AudioService.instance.startNotificationSound();

      final context = navigatorKey.currentContext;

      if (context == null) {
        return;
      }

      if (_isNotificationDialogShowing) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        _isNotificationDialogShowing = false;

        await Future.delayed(
          const Duration(milliseconds: 150),
        );
      }

      _isNotificationDialogShowing = true;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NotificationDialog(
            title: model.getTitle(context),
            subTitle: model.getDescription(context),
            onClose: () async {
              await AudioService.instance.stopNotificationSound();

              Navigator.pop(context);
            },
            onView: () async {
              await AudioService.instance.stopNotificationSound();

              _isNotificationDialogShowing = false;

              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();

              AppCubit.get(context).navigateToPage(
                PagesOfAllApp.dashboardOrderPageNumber,
              );
            },
          );
        },
      );

      _isNotificationDialogShowing = false;
    } catch (e, s) {
      _isNotificationDialogShowing = false;

      debugPrint(
        "ReceiveNotification Error => $e",
      );

      debugPrintStack(
        stackTrace: s,
      );
    }
  }

  //==========================================================
  // Handlers
  //==========================================================

  void _handleReceiveMessage(List<Object?>? arguments) {
    debugPrint("========== ReceiveMessage ==========");
    debugPrint(arguments.toString());
  }

  Future<void> _handleNewOrder(
    List<Object?>? arguments,
  ) async {
    try {
      final root = _getRoot(arguments);

      if (root == null) return;

      final model = SignalRNewOrderEvent.fromJson(root);

      if (!await model.data!.orderInfo!.canView()) {
        return;
      }
      await AudioService.instance.startNotificationSound();

      final context = navigatorKey.currentContext;

      if (context == null) {
        return;
      }

      if (_isNotificationDialogShowing) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        _isNotificationDialogShowing = false;

        await Future.delayed(
          const Duration(milliseconds: 150),
        );
      }

      _isNotificationDialogShowing = true;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NotificationDialog(
            title: OrderFunctions.formatDate(
                model.data?.orderInfo?.orderDate?.toString() ?? ""),
            subTitle: AppLanguageKeys.newOrders,
            onClose: () async {
              await AudioService.instance.stopNotificationSound();
              Navigator.pop(context);
            },
            onView: () async {
              await AudioService.instance.stopNotificationSound();

              _isNotificationDialogShowing = false;

              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();

              AppCubit.get(context).navigateToPage(
                PagesOfAllApp.dashboardOrderPageNumber,
              );
            },
          );
        },
      );

      _isNotificationDialogShowing = false;
    } catch (e, s) {
      debugPrint("NewOrder Error => $e");
      debugPrintStack(stackTrace: s);
    }
  }

  void _handleUpdateOrderStatus(List<Object?>? arguments) {
    debugPrint("========== UpdateOrderStatus ==========");
    debugPrint(arguments.toString());
  }

  void _handleNewServiceRequest(List<Object?>? arguments) {
    debugPrint("========== NewServiceRequest ==========");
    debugPrint(arguments.toString());
  }

  void _handleNewServiceOffer(List<Object?>? arguments) {
    debugPrint("========== NewServiceOffer ==========");
    debugPrint(arguments.toString());
  }

  void _handleTransferCarOwnership(List<Object?>? arguments) {
    debugPrint("========== TransferCarOwnership ==========");
    debugPrint(arguments.toString());
  }

  void _handleOpenCloseChat(List<Object?>? arguments) {
    debugPrint("========== OpenCloseChat ==========");
    debugPrint(arguments.toString());
  }
}

class NotificationModel {
  final int? id;
  final String? title;
  final String? latinTitle;
  final String? description;
  final String? latinDesc;
  final int? toUserId;
  final int? toUserType;
  final int? fromUserId;
  final int? fromUserType;
  final bool? isViewed;
  final DateTime? date;

  NotificationModel({
    this.id,
    this.title,
    this.latinTitle,
    this.description,
    this.latinDesc,
    this.toUserId,
    this.toUserType,
    this.fromUserId,
    this.fromUserType,
    this.isViewed,
    this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["ID"] ?? 0,
      title: json["TITLE"] ?? "",
      latinTitle: json["LATINTITLE"] ?? "",
      description: json["DESCRIPTION"] ?? "",
      latinDesc: json["LATINDESC"] ?? "",
      toUserId: json["TOUSERID"] ?? 0,
      toUserType: json["TOUSERTYPE"] ?? 0,
      fromUserId: json["FROMUSERID"] ?? 0,
      fromUserType: json["FROMUSERTYPE"] ?? 0,
      isViewed: json["ISVIEWED"] ?? false,
      date: DateTime.tryParse(json["DATE"] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "TITLE": title,
      "LATINTITLE": latinTitle,
      "DESCRIPTION": description,
      "LATINDESC": latinDesc,
      "TOUSERID": toUserId,
      "TOUSERTYPE": toUserType,
      "FROMUSERID": fromUserId,
      "FROMUSERTYPE": fromUserType,
      "ISVIEWED": isViewed,
      "DATE": date?.toIso8601String(),
    };
  }

  bool _isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  String getTitle(BuildContext context) {
    return _isEnglish(context) ? (latinTitle ?? "") : (title ?? "");
  }

  String getDescription(BuildContext context) {
    return _isEnglish(context) ? (latinDesc ?? "") : (description ?? "");
  }

  String getFormattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat(
      "dd MMM yyyy • hh:mm a",
      locale,
    ).format(date!);
  }
}

class SignalRNewOrderEvent {
  final int? userId;
  final int? userType;
  final String? title;
  final String? body;
  final NewOrderData? data;

  SignalRNewOrderEvent({
    this.userId,
    this.userType,
    this.title,
    this.body,
    this.data,
  });

  factory SignalRNewOrderEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    final bodyData = Map<String, dynamic>.from(json["data"]);

    return SignalRNewOrderEvent(
      userId: json["userId"] ?? 0,
      userType: json["userType"] ?? 0,
      title: bodyData["title"] ?? "",
      body: bodyData["body"] ?? "",
      data: NewOrderData?.fromJson(
        Map<String, dynamic>.from(bodyData["data"]),
      ),
    );
  }
}

class NewOrderData {
  final String? type;
  final int? orderId;
  final OrderInfo? orderInfo;

  NewOrderData({
    this.type,
    this.orderId,
    this.orderInfo,
  });

  factory NewOrderData.fromJson(
    Map<String, dynamic> json,
  ) {
    return NewOrderData(
      type: json["type"]?.toString() ?? "",
      orderId: _parseInt(json["orderId"]),
      orderInfo: OrderInfo.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(json["orderInfo"].toString()),
        ),
      ),
    );
  }
}

class OrderInfo {
  final int? id;
  final int? userId;
  final int? userType;
  final int? orderStatus;
  final String? userName;
  final DateTime? orderDate;
  final double? totalPrice;

  OrderInfo({
    this.id,
    this.userId,
    this.userType,
    this.orderStatus,
    this.userName,
    this.orderDate,
    this.totalPrice,
  });

  factory OrderInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderInfo(
      id: _parseInt(json["ID"]),
      userId: _parseInt(json["USERID"]),
      userType: _parseInt(json["USERTYPE"]),
      orderStatus: _parseInt(json["ORDERSTATUS"]),
      userName: json["USERNAME"]?.toString() ?? "",
      orderDate: DateTime.tryParse(
        json["ORDERDATE"]?.toString() ?? "",
      ),
      totalPrice: double.tryParse(json["TOTALPRICE"]?.toString() ?? "0") ?? 0,
    );
  }

  Future<bool> canView() async {
    final currentUser = await AuthLocalStorage.getUser();

    if (currentUser == null) {
      return false;
    }

    debugPrint("========== OrderInfo ==========");
    debugPrint("Current UserId   : ${currentUser.userid}");
    debugPrint("Current UserType : ${currentUser.type}");

    debugPrint("Order UserId     : $userId");
    debugPrint("Order UserType   : $userType");

    debugPrint("Order UserId     : $userId");
    debugPrint("Order UserType   : $userType");

    if (userType != currentUser.type) {
      debugPrint("❌ UserType Not Match");
      return false;
    }

    if (userId != currentUser.userid) {
      debugPrint("❌ UserId Not Match");
      return false;
    }

    debugPrint("✅ Order Accepted");
    return true;
  }
}

int _parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is num) return value.toInt();

  if (value is String) {
    return int.tryParse(value) ?? 0;
  }

  return 0;
}
