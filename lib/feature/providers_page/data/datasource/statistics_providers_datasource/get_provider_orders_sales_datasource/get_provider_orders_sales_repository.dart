import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';
import 'package:web_admin_san/feature/statistics_page/data/request/get_provider_orders_sales_request/get_provider_orders_sales_request.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/networking/network.dart';
import '../../../../../../core/networking/failures.dart';

Future<GetProviderOrdersSalesModel?> getProviderOrdersSalesFunction({
  required GetProviderOrdersSalesRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderOrdersSales,
    );

    final responseData = response.data;

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ?? 'Something went wrong',
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
