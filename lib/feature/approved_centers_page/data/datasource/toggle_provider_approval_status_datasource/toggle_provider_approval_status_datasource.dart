import 'package:dio/dio.dart';

import 'package:web_admin_san/feature/approved_centers_page/data/model/toggle_provider_approval_status_model/toggle_provider_approval_status_model.dart';
import 'package:web_admin_san/feature/approved_centers_page/data/request/toggle_provider_approval_status_request/toggle_provider_approval_status_request.dart';

import '../../../../../../../core/networking/api_link.dart';
import '../../../../../../../core/networking/network.dart';
import '../../../../../../../core/networking/failures.dart';

Future<ToggleProviderApprovalStatusModel?>
    toggleProviderApprovalStatusFunction({
  required ToggleProviderApprovalStatusRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.toggleProviderApprovalStatus,
    );

    final responseData = response.data;

    return ToggleProviderApprovalStatusModel.fromJson(
      responseData,
    );
  } catch (e) {
    if (e is DioException) {
      // لو الـ backend رجع message، نستخدمه
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        final message = data['message'];

        if (message != null) {
          throw Exception(message.toString());
        }
      }

      throw Exception(
        responseOfStatusCode(
          e.response?.statusCode,
        ),
      );
    }

    rethrow;
  }
}
