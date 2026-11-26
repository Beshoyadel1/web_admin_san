import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../model/create_user_model/create_user_request.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

class CreateUserResult {
  final bool success;
  final String message;

  CreateUserResult({
    required this.success,
    required this.message,
  });
}

Future<CreateUserResult> createUserFunction({
  required CreateUserRequest createUserRequest,
}) async {
  try {
    String jsonString = json.encode(
      createUserRequest.toJson(),
    );

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.createUser,
    );

    final Map<String, dynamic> body = response.data;

    return CreateUserResult(
      success: body["success"] ?? false,
      message: body["message"] ?? "",
    );
  } on DioException catch (e) {
    String errorMessage = LocaleKeys.somethingWentWrong.tr();

    if (e.response?.data != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        errorMessage = data["message"] ??
            responseOfStatusCode(
              e.response?.statusCode,
            );
      }
    }

    return CreateUserResult(
      success: false,
      message: errorMessage,
    );
  } catch (e) {
    return CreateUserResult(
      success: false,
      message: e.toString(),
    );
  }
}
