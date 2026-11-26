import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<void> makeNotificationViewedFunction({
  required GetUserNewNotificationRequest request,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.makeNotificationViewed,
    );
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
