import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/company/data/model/get_driver_details_model/get_driver_details_model.dart';
import 'package:web_admin_san/features/company/data/request/get_driver_details_request/get_driver_details_request.dart';

Future<GetDriverDetailsModel> getDriverDetailsFunction({
  required GetDriverDetailsRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getDriverDetails,
    );

    final responseData = response.data;

    final bool success = responseData["success"] ?? false;

    if (!success) {
      throw Exception(
        responseData["message"] ?? "Something went wrong",
      );
    }
    return GetDriverDetailsModel.fromJson(
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
