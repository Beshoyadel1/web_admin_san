import 'package:dio/dio.dart';

import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/coupon/data/model/coupon_statistics_model/coupon_statistics_model.dart';
import 'package:web_admin_san/features/coupon/data/request/get_coupon_statistics_request/get_coupon_statistics_request.dart';

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

    final bool success =
        responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ??
            'Failed to get coupon statistics',
      );
    }

    final List data =
        responseData['data'] ?? [];

    return data
        .map(
          (e) => CouponStatisticsModel.fromJson(e),
    )
        .toList();
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