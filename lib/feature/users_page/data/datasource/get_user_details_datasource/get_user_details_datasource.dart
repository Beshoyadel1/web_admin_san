import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/feature/users_page/data/model/user_details_model/user_details_model.dart';
import 'package:web_admin_san/feature/users_page/data/request/get_user_details_request/get_user_details_request.dart';

Future<UserDetailsResponse> getUserDetailsFunction({
  required GetUserDetailsRequest request,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getUserDetails,
    );

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
    throw Exception(e.toString());
  }
}
