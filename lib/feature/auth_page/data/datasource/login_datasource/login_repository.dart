import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/data/model/login_model/login_result.dart';
import '../../request/login_request/login_request.dart';

Future<LoginResult> loginFunction({
  required LoginRequest loginRequest,
}) async {
  try {
    final payload = loginRequest.toJson();
    final response = await Network.postDataWithBodyAndParams(
      payload,
      {'lang': 'ar'},
      ApiLink.loginUser,
    );

    final Map<String, dynamic> body = response.data;

    final bool success = body["success"] ?? false;

    final String message = body["message"] ??
        (success
            ? LocaleKeys.accountLoginSuccessfully
            : LocaleKeys.loginFailed);

    if (!success) {
      return LoginResult(
        success: false,
        message: message,
      );
    }

    final rawData = body["data"] ?? body["Data"];
    dynamic userDataJson;
    if (rawData is List && rawData.isNotEmpty) {
      userDataJson = rawData.first;
    } else if (rawData is Map) {
      userDataJson = rawData;
    }

    if (userDataJson == null) {
      return LoginResult(
        success: false,
        message: LocaleKeys.userNotFound.tr(),
      );
    }

    final user = CreateUserRequest.fromJson(
      Map<String, dynamic>.from(userDataJson),
    );

    await AuthLocalStorage.saveUser(
      user,
    );
    await AuthLocalStorage.savePassword(
      loginRequest.password,
    );

    return LoginResult(
      success: true,
      message: message,
      user: user,
    );
  } on DioException catch (e) {
    String errorMessage = LocaleKeys.somethingWentWrong;

    if (e.response?.data != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        errorMessage = data["message"] ??
            responseOfStatusCode(
              e.response?.statusCode,
            );
      }
    }

    return LoginResult(
      success: false,
      message: errorMessage,
    );
  } catch (e) {
    return LoginResult(
      success: false,
      message: e.toString(),
    );
  }
}
