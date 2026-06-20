import 'package:dio/dio.dart';
import 'package:web_admin_san/features/rates/data/model/get_provider_details_rates_model/get_provider_details_rates_model.dart';
import '../../request/get_provider_details_rates_request/get_provider_details_rates_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<ProviderDetailsRatesModel> getProviderDetailsRatesFunction({
  required GetProviderDetailsRatesRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderDetailsRates,
    );

    final json = response.data as Map<String, dynamic>;

    if (json["success"] != true || json["data"] == null) {
      throw Exception("No Data Found");
    }

    return ProviderDetailsRatesModel.fromJson(
      json["data"],
    );
  } on DioException catch (e) {
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