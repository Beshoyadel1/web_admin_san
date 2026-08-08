import 'package:dio/dio.dart';
import 'package:web_admin_san/features/order_services/data/model/get_provider_service_statistics_model/provider_statistics_model.dart';
import 'package:web_admin_san/features/order_services/data/request/get_provider_service_statistics_request/get_provider_service_statistics_request.dart';

import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';

Future<ProviderStatisticsModel?> getProviderServiceStatisticsFunction({
  required GetProviderServiceStatisticsRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderServiceStatistics,
    );

    final responseData = response.data;

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ?? 'Something went wrong',
      );
    }

    return ProviderStatisticsModel.fromJson(responseData);
  } catch (e) {
    if (e is DioException) {
      throw Exception(
        responseOfStatusCode(
          e.response?.statusCode,
        ),
      );
    }

    rethrow;
  }
}