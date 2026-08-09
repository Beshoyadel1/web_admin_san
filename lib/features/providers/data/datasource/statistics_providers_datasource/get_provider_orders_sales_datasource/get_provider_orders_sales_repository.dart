import 'package:dio/dio.dart';
import '../../../../../../features/order_services/data/model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';
import '../../../../../../features/order_services/data/request/get_provider_orders_sales_request/get_provider_orders_sales_request.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../core/api/dio_function/failures.dart';

Future<GetProviderOrdersSalesModel?>
getProviderOrdersSalesFunction({
  required GetProviderOrdersSalesRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderOrdersSales,
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

    return GetProviderOrdersSalesModel.fromJson(
      responseData,
    );
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