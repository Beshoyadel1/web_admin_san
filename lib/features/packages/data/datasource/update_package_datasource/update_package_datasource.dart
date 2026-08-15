import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:web_admin_san/features/packages/data/model/get_packages_model/get_packages_model.dart';

import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<PackageModel> updatePackageFunction({
  required PackageModel packageModel,
}) async {
  try {
    final jsonString = jsonEncode(
      packageModel.toJson(
      ),
    );

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.updatePackage,
    );

    final responseData = response.data;

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ??
            'Update package failed',
      );
    }

    return PackageModel.fromJson(
      responseData['data'],
    );
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data['message']?.toString() ??
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
      e.toString().replaceFirst(
        'Exception: ',
        '',
      ),
    );
  }
}