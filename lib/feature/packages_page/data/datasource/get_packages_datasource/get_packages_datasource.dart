import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';

import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<List<PackageModel>> getPackagesFunction() async {
  try {
    final response = await Network.getData(
      ApiLink.getPackages,
    );

    final json = response.data;
    if (json is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    final bool success = json['success'] ?? false;
    if (!success) {
      throw Exception(
        json['message']?.toString() ?? 'Failed to get packages',
      );
    }

    if (json['data'] != null) {
      final List<dynamic> data = json['data'];

      return data
          .map(
            (item) => PackageModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    return [];
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
