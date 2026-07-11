import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import '../../../../../../core/audio_service/audio_service.dart';
import '../../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../features/notifications/presentation/pages/notification_dialog/notification_dialog.dart';
import '../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../../../main.dart';

class SignalRService {
  bool _isNotificationDialogShowing = false;

  SignalRService._();

  static final SignalRService instance = SignalRService._();

  HubConnection? _hubConnection;

  HubConnection? get connection => _hubConnection;

  bool get isConnected =>
      _hubConnection?.state == HubConnectionState.connected;

  Future<void> connect({
    required String hubUrl,
  }) async {
    if (isConnected) {
      print("✅ SignalR Already Connected");
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
           // print("SIGNALR => $message");
          },
        ),
      )
          .build();


      /// ================= Connection Events =================
      _hubConnection!.onclose((error) async {
        print("SignalR Closed => $error");

        await Future.delayed(const Duration(seconds: 3));

        if (!isConnected) {
          await connect(hubUrl: hubUrl);
        }
      });

      _hubConnection!.onreconnected((connectionId) {
        print("🟢 SignalR Reconnected");
        print("ConnectionId => $connectionId");
      });

      /// ================= Notifications =================
      _hubConnection!.on("ReceiveNotification", (arguments) async {
        try {
          if (arguments == null || arguments.isEmpty) return;

          final currentUser = await AuthLocalStorage.getUser();
          if (currentUser == null) return;

          final root = Map<String, dynamic>.from(arguments.first);

          final int? userId = root["userId"];
          final int? userType = root["userType"];

          if (userType != currentUser.type) return;

          if (userId != null &&
              userId != 0 &&
              userId != currentUser.userid) {
            return;
          }

          final notification =
          Map<String, dynamic>.from(root["data"]);

          final data =
          Map<String, dynamic>.from(notification["data"]);

          final notificationJson = jsonDecode(
            data["notification"] as String,
          ) as Map<String, dynamic>;

          final model = NotificationModel.fromJson(notificationJson);

          await AudioService.instance.startNotificationSound();

          final context = navigatorKey.currentContext;

          if (context == null) return;

          if (_isNotificationDialogShowing) {
            Navigator.of(context, rootNavigator: true).pop();

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
                notification: model,
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
                  AppCubit.get(context).navigateToPage(PagesOfAllApp.dashboardOrderPageNumber);
                },
              );
            },
          );

          _isNotificationDialogShowing = false;
        } catch (e, s) {
          _isNotificationDialogShowing = false;

          debugPrint("ReceiveNotification Error => $e");
          debugPrintStack(stackTrace: s);
        }
      });

      _hubConnection!.on("ReceiveMessage", (arguments) {
        print("========== RAW ==========");
        print(arguments);
        print("=========================");
        if (arguments == null || arguments.isEmpty) return;

        final root = Map<String, dynamic>.from(arguments.first);

        if (root["Data"] == null) {
          print("No Data received");
          return;
        }

        final notification = Map<String, dynamic>.from(root["Data"] as Map);

        print("UserId => ${root["UserId"]}");
        print("UserType => ${root["UserType"]}");
        print("Title => ${notification["title"]}");
        print("Body => ${notification["body"]}");

        final data =
        Map<String, dynamic>.from(notification["data"]);

        final notificationModel =
        NotificationModel.fromJson(data["notification"]);

        print(notificationModel.title);
        print(notificationModel.description);
      });

      _hubConnection!.on("NewOrder", (arguments) {
      });

      _hubConnection!.on("UpdateOrderStatus", (arguments) {
      });
      _hubConnection!.on("NewServiceRequest", (arguments) {
      });
      _hubConnection!.on("NewServiceOffer", (arguments) {
      });

      _hubConnection!.on("TransferCarOwnership", (arguments) {
      });
      _hubConnection!.on("OpenCloseChat", (arguments) {
      });

      await _hubConnection!.start();

    } catch (e, s) {

      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      if (_hubConnection != null) {
        await _hubConnection!.stop();
      }
    } catch (_) {}

    _hubConnection = null;
  }

}

class NotificationModel {
  final int id;
  final String title;
  final String latinTitle;
  final String description;
  final String latinDesc;
  final int toUserId;
  final int toUserType;
  final int fromUserId;
  final int fromUserType;
  final bool isViewed;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.latinTitle,
    required this.description,
    required this.latinDesc,
    required this.toUserId,
    required this.toUserType,
    required this.fromUserId,
    required this.fromUserType,
    required this.isViewed,
    required this.date,
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
      "DATE": date.toIso8601String(),
    };
  }
  bool _isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  String getTitle(BuildContext context) {
    return _isEnglish(context)
        ? (latinTitle ?? "")
        : (title ?? "");
  }

  String getDescription(BuildContext context) {
    return _isEnglish(context)
        ? (latinDesc ?? "")
        : (description ?? "");
  }

  String getFormattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat(
      "dd MMM yyyy • hh:mm a",
      locale,
    ).format(date);
  }
}