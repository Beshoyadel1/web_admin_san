import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/users/data/model/get_all_users_models/get_all_users_models.dart';
import 'package:web_admin_san/features/users/data/model/user_details_model/user_details_model.dart';
import 'package:web_admin_san/features/users/data/request/get_all_user_request/get_all_user_request.dart';
import 'package:web_admin_san/features/users/data/request/get_user_details_request/get_user_details_request.dart';

Future<UserDetailsResponse> getUserDetailsFunction({
  required GetUserDetailsRequest request,
}) async {
  try {
    final response =
    await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getUserDetails,
    );

    print("RESPONSE = ${response.data}");

    final responseData = response.data;

    final bool success = responseData["success"] ?? false;

    if (!success) {
      throw Exception(
        responseData["message"] ?? "Something went wrong",
      );
    }

    return UserDetailsResponse.fromJson(
      responseData["data"],
    );
  } on DioException catch (e) {
    print(
      "DIO ERROR = ${e.response?.data}",
    );

    print(
      "STATUS CODE = ${e.response?.statusCode}",
    );

    print(
      "STACK = ${e.stackTrace}",
    );

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
  } catch (e, stackTrace) {
    print("ERROR = $e");
    print("STACK = $stackTrace");

    throw Exception(e.toString());
  }
}
