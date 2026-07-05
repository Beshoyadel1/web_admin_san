import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../request/send_message_request/send_message_request.dart';

Future<void> sendMessageFunction({required SendMessageRequest sendMessageRequest}) async {
  try {
    String jsonString = json.encode(sendMessageRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.sendMessage,
    ).then((value) {
    });
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}