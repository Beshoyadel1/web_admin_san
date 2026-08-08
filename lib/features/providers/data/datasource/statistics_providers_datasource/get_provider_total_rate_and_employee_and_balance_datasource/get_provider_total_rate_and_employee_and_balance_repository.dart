import 'package:dio/dio.dart';
import 'package:web_admin_san/features/order_services/data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import 'package:web_admin_san/features/order_services/data/request/get_provider_total_rate_and_employee_and_balance_request/get_provider_total_rate_and_employee_and_balance_request.dart';

import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../core/api/dio_function/failures.dart';

Future<GetProviderTotalRateAndEmployeeAndBalanceModel?>
getProviderTotalRateAndEmployeeAndBalanceFunction({
  required GetProviderTotalRateAndEmployeeAndBalanceRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderTotalRateAndEmployeeAndBalance,
    );

    final responseData = response.data;

    final bool success =
        responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ??
            'Something went wrong',
      );
    }

    return GetProviderTotalRateAndEmployeeAndBalanceModel
        .fromJson(responseData);
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