import 'package:dio/dio.dart';

import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import '../../model/get_packages_model/get_packages_model.dart';
import 'dart:convert';

Future<PackageModel> createPackageFunction({
  required PackageModel packageModel,
}) async {
  try {
    final jsonString = jsonEncode(
      packageModel.toJson(),
    );

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.createPackage,
    );

    final responseData = response.data;

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ?? 'Create package failed',
      );
    }

    if (responseData['data'] is Map<String, dynamic>) {
      return PackageModel.fromJson(
        responseData['data'] as Map<String, dynamic>,
      );
    }

    return packageModel;
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
