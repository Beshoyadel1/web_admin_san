import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/accounts_management_page/data/request/get_provider_balance_details_request/get_provider_balance_details_request.dart';
import 'package:web_admin_san/feature/accounts_management_page/data/model/get_provider_balance_details_model/provider_balance_details_model.dart';
import '../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<ProviderBalanceDetailsModel?> getProviderBalanceDetailsFunction({
  required GetProviderBalanceDetailsRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderBalanceDetails,
    );
    return ProviderBalanceDetailsModel.fromJson(response.data);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
    return null;
  }
}
