import 'package:dio/dio.dart';

import 'package:web_admin_san/features/approved_centers/data/model/toggle_provider_approval_status_model/toggle_provider_approval_status_model.dart';
import 'package:web_admin_san/features/approved_centers/data/request/toggle_provider_approval_status_request/toggle_provider_approval_status_request.dart';

import '../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../../core/api/dio_function/failures.dart';

Future<ToggleProviderApprovalStatusModel?>
toggleProviderApprovalStatusFunction({
  required ToggleProviderApprovalStatusRequest request,
}) async {
  try {
    print('========== TOGGLE APPROVAL ==========');
    print('URL: ${ApiLink.toggleProviderApprovalStatus}');
    print('QUERY: ${request.toJson()}');

    final response =
    await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.toggleProviderApprovalStatus,
    );

    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE: ${response.data}');

    final responseData = response.data;

    return ToggleProviderApprovalStatusModel.fromJson(
      responseData,
    );
  } catch (e) {
    print('========== TOGGLE APPROVAL ERROR ==========');
    print(e);

    if (e is DioException) {
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');

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