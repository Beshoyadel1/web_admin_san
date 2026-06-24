import 'package:dio/dio.dart';
import '../../../../../../features/cars_haraj_page/data/request/get_user_harages_request/get_user_harages_request.dart';
import '../../../../../../features/cars_haraj_page/data/response/get_all_harage_response/get_all_harage_response.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<GetAllHarageResponse> getUserHaragesFunction({
  required GetUserHaragesRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getUserHarages,
    );

    return GetAllHarageResponse.fromJson(
      response.data,
    );
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}