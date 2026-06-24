import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/cars_haraj_page/data/model/get_harage_providers_models/get_harage_providers_models.dart';
import 'package:web_admin_san/features/cars_haraj_page/data/request/get_harage_providers_request/get_harage_providers_request.dart';

Future<GetHarageProvidersModels> getHarageProviders({
  required GetHarageProvidersRequest request,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getHarageProviders,
    );

    final responseData = response.data;

    final bool success = responseData["success"] ?? false;

    print("Data: ${responseData["data"]}");
    if (!success) {
      throw Exception(
        responseData["message"] ?? "Something went wrong",
      );
    }
    return GetHarageProvidersModels.fromJson(
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
