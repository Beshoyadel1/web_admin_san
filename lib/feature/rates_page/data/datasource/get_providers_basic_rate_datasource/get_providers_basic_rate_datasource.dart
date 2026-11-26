import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/rates_page/data/model/get_providers_basic_rate_models/get_providers_basic_rate_models.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';

Future<List<ProviderRateModel>> getProvidersBasicRateFunction() async {
  try {
    final response = await Network.getData(
      ApiLink.getProvidersBasicRate,
    );

    final json = response.data as Map<String, dynamic>;

    if (json['success'] == true && json['data'] != null) {
      return (json['data'] as List)
          .map(
            (e) => ProviderRateModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    return [];
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    return [];
  }
}
