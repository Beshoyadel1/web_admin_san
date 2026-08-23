import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/features/warranty/data/model/warranty_model/warranty_model.dart';

Future<List<WarrantyModel>?> getApprovalsFunction() async {
  try {
    final response = await Network.getData(
      ApiLink.getApprovalInfo,
    );

    final json = response.data as Map<String, dynamic>;

    if (json['success'] == true && json['data'] != null) {
      final List<dynamic> data = json['data'];

      return data
          .map(
            (item) => WarrantyModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList();
    }

    return null;
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(
        e.response?.statusCode,
      )
          : e.toString(),
    );

    return null;
  }
}