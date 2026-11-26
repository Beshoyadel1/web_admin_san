import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
class UpdateUserResult {
  final bool success;

  final String message;

  const UpdateUserResult({
    required this.success,
    required this.message,
  });
}

Future<UpdateUserResult> updateUserFunction({
  required CreateUserRequest createUserRequest,
}) async {
  try {
    final response = await Network.postDataWithBody(
      createUserRequest.toJson(),
      ApiLink.updateUser,
    );
    final Map<String, dynamic> body = response.data;

    final bool success = body["success"] ?? false;

    final String message =
        body["message"] ?? LocaleKeys.somethingWentWrong;

    return UpdateUserResult(
      success: success,
      message: message,
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

    return UpdateUserResult(
      success: false,
      message: errorMessage,
    );
  } catch (e) {
    return UpdateUserResult(
      success: false,
      message: e.toString(),
    );
  }
}
