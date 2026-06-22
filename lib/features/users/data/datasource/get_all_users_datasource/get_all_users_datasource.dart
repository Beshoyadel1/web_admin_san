import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/users/data/model/get_all_users_models/get_all_users_models.dart';
import 'package:web_admin_san/features/users/data/request/get_all_user_request/get_all_user_request.dart';

Future<GetAllUsersResponse>
getAllUsersFunction({
  required GetAllUserRequest request,
}) async {
  try {
    final response =
    await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getAllUsers,
    );

    final responseData = response.data;

    final bool success =
        responseData["success"] ?? false;

    if (!success) {
      throw Exception(
        responseData["message"] ??
            "Something went wrong",
      );
    }
    return GetAllUsersResponse.fromJson(
      responseData["data"],
    );
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {

      throw Exception(
        data["message"] ??
            responseOfStatusCode(
              e.response?.statusCode,
            ),
      );
    }

    throw Exception(
      responseOfStatusCode(
        e.response?.statusCode,
      ),
    );
  } catch (e) {
    throw Exception(
      e.toString(),
    );
  }
}