import 'package:dio/dio.dart';

import 'package:web_admin_san/feature/cars_haraj_page/data/request/get_all_harage_request/get_all_harage_request.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/response/get_all_harage_response/get_all_harage_response.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<GetAllHarageResponse> getAllHarageFunction({
  required GetAllHarageRequest getAllHarageRequest,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      getAllHarageRequest.toJson(),
      ApiLink.getAllHarage,
    );

    final data = GetAllHarageResponse.fromJson(response.data);

    return data;
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
