import 'dart:convert';
import 'package:web_admin_san/core/networking/local_services.dart';

String decodeArabic(String? text) {
  if (text == null || text.isEmpty) {
    return '';
  }

  try {
    return utf8.decode(
      latin1.encode(text),
    );
  } catch (_) {
    return text;
  }
}

int? _parseInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(
    value.toString(),
  );
}

class ReceiveMessageNotificationModel {
  final int? userId;
  final int? userType;
  final ReceiveMessageNotificationData? data;

  ReceiveMessageNotificationModel({
    this.userId,
    this.userType,
    this.data,
  });

  factory ReceiveMessageNotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    ReceiveMessageNotificationData? parsedData;
    if (json['data'] is Map) {
      parsedData = ReceiveMessageNotificationData.fromJson(
        Map<String, dynamic>.from(
          json['data'] as Map,
        ),
      );
    } else if (json.containsKey('fromUser') ||
        json.containsKey('fromuser') ||
        json.containsKey('message') ||
        json.containsKey('body')) {
      parsedData = ReceiveMessageNotificationData.fromJson(json);
    }

    return ReceiveMessageNotificationModel(
      userId: _parseInt(
        json['userId'] ?? json['userid'] ?? json['toUser'] ?? json['touser'],
      ),
      userType: _parseInt(
        json['userType'] ??
            json['usertype'] ??
            json['toUserType'] ??
            json['tousertype'],
      ),
      data: parsedData,
    );
  }

  // ==========================================================
  // CAN VIEW
  // ==========================================================

  Future<bool> canView() async {
    final currentUser = await AuthLocalStorage.getUser();

    if (currentUser == null) {
      return false;
    }

    // In web_admin_san, all logged-in administrators can view support chat notifications
    return true;
  }
}

class ReceiveMessageNotificationData {
  final String? title;
  final String? body;
  final ReceiveMessageData? data;

  ReceiveMessageNotificationData({
    this.title,
    this.body,
    this.data,
  });

  factory ReceiveMessageNotificationData.fromJson(
    Map<String, dynamic> json,
  ) {
    ReceiveMessageData? innerData;
    if (json['data'] is Map) {
      innerData = ReceiveMessageData.fromJson(
        Map<String, dynamic>.from(
          json['data'] as Map,
        ),
      );
    } else if (json.containsKey('fromUser') ||
        json.containsKey('fromuser') ||
        json.containsKey('message') ||
        json.containsKey('text') ||
        json.containsKey('body')) {
      innerData = ReceiveMessageData.fromJson(json);
    }

    return ReceiveMessageNotificationData(
      title: json['title']?.toString() ??
          json['fromUserName']?.toString() ??
          json['fromusername']?.toString(),
      body: json['body']?.toString() ??
          json['message']?.toString() ??
          json['description']?.toString(),
      data: innerData,
    );
  }
}

class ReceiveMessageData {
  final String? type;
  final String? id;

  final String? fromUser;
  final String? toUser;

  final String? message;
  final String? date;
  final String? viewed;

  final String? fromUserType;
  final String? toUserType;

  final String? isClosed;
  final String? fromUserName;

  final String? harageId;
  final String? orderId;

  ReceiveMessageData({
    this.type,
    this.id,
    this.fromUser,
    this.toUser,
    this.message,
    this.date,
    this.viewed,
    this.fromUserType,
    this.toUserType,
    this.isClosed,
    this.fromUserName,
    this.harageId,
    this.orderId,
  });

  factory ReceiveMessageData.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReceiveMessageData(
      type: _getJsonValue(json, 'type')?.toString(),
      id: _getJsonValue(json, 'id')?.toString(),
      fromUser: _getJsonValue(json, 'fromuser')?.toString(),
      toUser: _getJsonValue(json, 'touser')?.toString(),
      message: decodeArabic(
        _getJsonValue(
          json,
          'message',
        )?.toString(),
      ),
      date: _getJsonValue(json, 'date')?.toString(),
      viewed: _getJsonValue(json, 'viewed')?.toString(),
      fromUserType: _getJsonValue(
        json,
        'fromusertype',
      )?.toString(),
      toUserType: _getJsonValue(
        json,
        'tousertype',
      )?.toString(),
      isClosed: _getJsonValue(
        json,
        'isclosed',
      )?.toString(),
      fromUserName: decodeArabic(
        _getJsonValue(
          json,
          'fromusername',
        )?.toString(),
      ),
      harageId: _getJsonValue(
        json,
        'harageid',
      )?.toString(),
      orderId: _getJsonValue(
        json,
        'orderid',
      )?.toString(),
    );
  }
}

dynamic _getJsonValue(
  Map<String, dynamic> json,
  String key,
) {
  final target = key.toLowerCase();

  for (final entry in json.entries) {
    if (entry.key.toLowerCase() == target) {
      return entry.value;
    }
  }

  return null;
}
