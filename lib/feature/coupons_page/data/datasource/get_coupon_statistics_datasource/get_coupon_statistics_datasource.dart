import 'package:dio/dio.dart';

import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_statistics_model/coupon_statistics_model.dart';
import 'package:web_admin_san/feature/coupons_page/data/request/get_coupon_statistics_request/get_coupon_statistics_request.dart';

Future<List<CouponStatisticsModel>> getCouponStatisticsFunction({
  required GetCouponStatisticsRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getStaticsForCoupon,
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ?? 'Failed to get coupon statistics',
      );
    }

    final rawData = responseData['data'];

    if (rawData is Map<String, dynamic>) {
      return [CouponStatisticsModel.fromJson(rawData)];
    } else if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => CouponStatisticsModel.fromJson(e),
          )
          .toList();
    }

    return [];
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
