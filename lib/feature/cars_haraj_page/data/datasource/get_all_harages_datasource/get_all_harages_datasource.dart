import 'package:dio/dio.dart';
import '../../../../../../../core/networking/api_link.dart';
import '../../../../../../../core/networking/network.dart';
import '../../../../../../../core/networking/failures.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/get_all_harages_request/get_all_harages_request.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/response/get_all_harage_response/get_all_harage_response.dart';

Future<GetAllHarageResponse> getAllHaragesFunction({
  required GetAllHaragesRequest request,
}) async {
  try {
    final response = await Network.getDataWithParams(
      request.toJson(),
      ApiLink.getAllHarages,
    );

    final responseData = response.data;

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ?? 'Something went wrong',
      );
    }

    return GetAllHarageResponse.fromJson(
      responseData['data'],
    );
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data['message'] ??
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
