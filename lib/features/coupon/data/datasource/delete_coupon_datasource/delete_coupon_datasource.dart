import 'package:dio/dio.dart';

import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/coupon/data/request/delete_coupon_request/delete_coupon_request.dart';

Future<String> deleteCouponFunction({
  required DeleteCouponRequest request,
}) async {
  try {
    final response =
    await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.deleteCoupon,
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw Exception(
        'Invalid response format',
      );
    }

    final bool success =
        responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ??
            'Failed to delete coupon',
      );
    }

    return responseData['message']?.toString() ??
        'Coupon deleted successfully';

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