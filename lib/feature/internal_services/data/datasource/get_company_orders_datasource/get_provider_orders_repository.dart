import 'package:dio/dio.dart';

import 'package:web_admin_san/feature/internal_services/data/request/get_provider_orders_request/get_provider_orders_request.dart';
import 'package:web_admin_san/feature/internal_services/data/response/get_provider_orders_response/get_provider_orders_response.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';

Future<GetProviderOrdersResponse> getCompanyOrderFunction({
  required GetProviderOrdersRequest getProviderOrdersRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      getProviderOrdersRequest.toJson(),
      ApiLink.getCompanyOrders,
    );

    final result = GetProviderOrdersResponse.fromJson(response.data);

    return result;
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    rethrow;
  }
}
