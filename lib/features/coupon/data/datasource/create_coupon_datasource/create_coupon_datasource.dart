import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/coupon/data/model/coupon_model/coupon_model.dart';


Future<int> createCouponFunction({
  required CouponWithProviderModel request,
}) async {
  try {
    final jsonString = jsonEncode(
      request.toJson(),
    );

    final response =
    await Network.postDataWithBody(
      jsonString,
      ApiLink.createCoupon,
    );

    final responseData =
        response.data;

    if (responseData
    is! Map<String, dynamic>) {
      throw Exception(
        'Invalid response format',
      );
    }

    final bool success =
        responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ??
            'Failed to create coupon',
      );
    }

    final data =
    responseData['data'];

    if (data == null) {
      throw Exception(
        'Coupon ID was not returned',
      );
    }

    return int.parse(
      data.toString(),
    );
  } on DioException catch (e) {
    final data =
        e.response?.data;

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