import 'package:dio/dio.dart';

import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/feature/coupons_page/data/request/delete_coupon_request/delete_coupon_request.dart';

Future<String> deleteCouponFunction({
  required DeleteCouponRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
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

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ?? 'Failed to delete coupon',
      );
    }

    return responseData['message']?.toString() ?? 'Coupon deleted successfully';
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
