import 'dart:convert';
import 'package:web_admin_san/feature/notifications/data/datasource/parsers/root_parser/root_parser.dart';
import 'package:web_admin_san/feature/notifications/data/model/receive_notification_model/receive_notification_model.dart';

class ReceiveNotificationParser {
  ReceiveNotificationParser({
    RootParser? rootParser,
  }) : _rootParser = rootParser ?? const RootParser();

  final RootParser _rootParser;

  ReceiveNotificationModel? parse(List<Object?>? arguments) {
    final root = _rootParser.parse(arguments);

    if (root == null) {
      return null;
    }

    try {
      // 1. Try legacy SignalR nested structure
      if (root["data"] is Map) {
        final notification = Map<String, dynamic>.from(root["data"] as Map);
        if (notification["data"] is Map) {
          final data = Map<String, dynamic>.from(notification["data"] as Map);
          if (data["notification"] is String) {
            final notificationJson = jsonDecode(
              data["notification"] as String,
            ) as Map<String, dynamic>;
            return ReceiveNotificationModel.fromJson(notificationJson);
          }
        }
        return ReceiveNotificationModel.fromJson(notification);
      }
    } catch (_) {}

    return ReceiveNotificationModel.fromJson(root);
  }

  int? getUserId(List<Object?>? arguments) {
    final root = _rootParser.parse(arguments);
    if (root == null) return null;
    final raw = root["userId"] ??
        root["userid"] ??
        root["USERID"] ??
        root["toUser"] ??
        root["touser"];
    return raw is int ? raw : int.tryParse(raw?.toString() ?? '');
  }

  int? getUserType(List<Object?>? arguments) {
    final root = _rootParser.parse(arguments);
    if (root == null) return null;
    final raw = root["userType"] ??
        root["usertype"] ??
        root["USERTYPE"] ??
        root["toUserType"] ??
        root["tousertype"];
    return raw is int ? raw : int.tryParse(raw?.toString() ?? '');
  }
}
