import 'package:dio/dio.dart';
import 'package:web_admin_san/features/packages/data/model/get_packages_model/get_packages_model.dart';
import '../../../../../../../features/accounts_management/data/request/get_package_request/get_package_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<PackageModel> getPackageFunction({
  required GetPackageRequest request,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getPackage,
    );

    final responseData = response.data;

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message']?.toString() ??
            'Something went wrong',
      );
    }

    return PackageModel.fromJson(
      responseData['data'],
    );
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data['message']?.toString() ??
            responseOfStatusCode(e.response?.statusCode),
      );
    }

    throw Exception(
      responseOfStatusCode(
        e.response?.statusCode,
      ),
    );
  }
}