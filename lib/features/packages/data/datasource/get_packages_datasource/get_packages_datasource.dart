import 'package:dio/dio.dart';
import 'package:web_admin_san/features/packages/data/model/get_packages_model/get_packages_model.dart';

import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';

Future<List<PackageModel>?> getPackagesFunction() async {
  try {
    final response = await Network.getData(
      ApiLink.getPackages,
    );

    final json = response.data as Map<String, dynamic>;

    if (json['success'] == true && json['data'] != null) {
      final List<dynamic> data = json['data'];

      return data
          .map(
            (item) => PackageModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    return null;
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    return null;
  }
}