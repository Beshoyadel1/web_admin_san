import 'package:dio/dio.dart';
import 'package:web_admin_san/features/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';

import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

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