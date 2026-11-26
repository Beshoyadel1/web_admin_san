import 'package:dio/dio.dart';
import '../../../../../../../../core/networking/api_link.dart';
import '../../../../../../../../core/networking/network.dart';
import '../../../../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/warranty_page/data/model/warranty_model/warranty_model.dart';

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
