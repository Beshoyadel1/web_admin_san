import 'package:dio/dio.dart';

import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';

import 'package:web_admin_san/features/approved_centers/data/model/get_approved_providers_model/get_approved_providers_model.dart';
import 'package:web_admin_san/features/approved_centers/data/request/get_approved_providers_request/get_approved_providers_request.dart';

Future<GetApprovedProvidersResponse>
getApprovedProvidersFunction({
  required GetApprovedProvidersRequest request,
}) async {
  try {
    final response =
    await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getApprovedProviders,
    );

    final responseData = response.data;

    final bool success =
        responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ??
            'Something went wrong',
      );
    }

    return GetApprovedProvidersResponse.fromJson(
      responseData['data'],
    );
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data['message'] ??
            responseOfStatusCode(
              e.response?.statusCode,
            ),
      );
    }

    throw Exception(
      responseOfStatusCode(
        e.response?.statusCode,
      ),
    );
  } catch (e) {
    throw Exception(
      e.toString(),
    );
  }
}