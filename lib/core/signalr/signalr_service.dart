import 'dart:convert';
import 'dart:typed_data';

import 'package:signalr_core/signalr_core.dart';
import 'package:web_admin_san/features/auth_page/data/datasource/login_datasource/login_repository.dart';

class SignalRService {
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
            print("SIGNALR => $message");
          },
        ),
      )
          .build();


      /// ================= Connection Events =================
      _hubConnection!.onclose((error) async {
        print("SignalR Closed => $error");

        await Future.delayed(const Duration(seconds: 5));

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
        if (arguments == null || arguments.isEmpty) return;

        final currentUser = await AuthLocalStorage.getUser();
        if (currentUser == null) return;

        final root = Map<String, dynamic>.from(arguments.first as Map);

        final int userId = root["userId"] as int;
        final int userType = root["userType"] as int;

        // تجاهل الإشعار إذا لم يكن لهذا المستخدم
        if (userId != currentUser.userid ||
            userType != currentUser.type) {
          return;
        }

        final notification =
        Map<String, dynamic>.from(root["data"] as Map);

        print("Title => ${notification["title"]}");
        print("Body => ${notification["body"]}");

        final data =
        Map<String, dynamic>.from(notification["data"] as Map);

        print(data);
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

        final message = Messages.fromJson(
          Map<String, dynamic>.from(notification["data"]),
        );

        print("Message => ${message.message}");
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

      print("=================================");
      print("✅ SignalR Connected Successfully");
      print("State => ${_hubConnection!.state}");
      print("ConnectionId => ${_hubConnection!.connectionId}");
      print("=================================");

      await Future.delayed(const Duration(seconds: 3));

      try {
        print("Calling Ping...");
        final result = await _hubConnection!.invoke("Ping");
        print("Ping Result => $result");
      } catch (e) {
        print("Ping Error => $e");
      }

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


class Messages {
  int? fromuser;
  int? fromusertype;
  int? touser;
  int? tousertype;

  String? message;
  String? date;
  String? fromusername;

  bool? viewed;
  bool? isclosed;

  Uint8List? image;

  Messages({
    this.fromuser,
    this.fromusertype,
    this.touser,
    this.tousertype,
    this.message,
    this.date,
    this.fromusername,
    this.viewed,
    this.isclosed,
    this.image,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      fromuser: json["fromuser"],
      fromusertype: json["fromusertype"],
      touser: json["touser"],
      tousertype: json["tousertype"],
      message: json["message"],
      date: json["date"],
      fromusername: json["fromusername"],
      viewed: json["viewed"],
      isclosed: json["isclosed"] ?? true,
      image: json["image"] != null &&
          json["image"].toString().isNotEmpty
          ? base64Decode(json["image"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fromuser": fromuser,
      "fromusertype": fromusertype,
      "touser": touser,
      "tousertype": tousertype,
      "message": message,
      "date": date,
      "fromusername": fromusername,
      "viewed": viewed,
      "isclosed": isclosed,
      "image": image != null ? base64Encode(image!) : null,
    };
  }
}