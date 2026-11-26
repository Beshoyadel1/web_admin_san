import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
class AppErrorHandler {
  static String formatError(dynamic error, {int? statusCode, String? fallback}) {
    if (error == null) {
      if (statusCode != null) return responseOfStatusCode(statusCode);
      return fallback?.trim().isNotEmpty == true
          ? fallback!.trim()
          : LocaleKeys.oopsErrorTryAgain;
    }

    if (error is DioException) {
      final code = error.response?.statusCode;
      if (code != null) return responseOfStatusCode(code);
      return responseOfStatusCode(null);
    }

    if (error is String) {
      return error;
    }

    return error.toString();
  }
}
