import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';

Future<List<CarGroupModel>> getCarGroupsFunction({
  required int companyId,
}) async {
  try {
    Response response;
    try {
      // In benchmark company system, CarGroup/GetCarGroups is invoked via POST with query parameters
      response = await Network.postDataWithQuery(
        {'companyId': companyId},
        ApiLink.getCarGroups,
      );
    } on DioException catch (dioErr) {
      if (dioErr.response?.statusCode == 405) {
        // Fallback to GET if method not allowed
        response = await Network.getDataWithParams(
          {'companyId': companyId},
          ApiLink.getCarGroups,
        );
      } else {
        rethrow;
      }
    }

    final responseData = response.data;

    if (responseData is List) {
      return responseData
          .map((item) => CarGroupModel.fromJson(item is Map<String, dynamic>
              ? item
              : Map<String, dynamic>.from(item as Map)))
          .toList();
    }

    if (responseData is Map<String, dynamic>) {
      final bool? success = responseData['success'];
      if (success == false) {
        throw Exception(responseData['message'] ?? 'Failed to load car groups');
      }

      final data = responseData['data'];
      if (data is List) {
        return data
            .map((item) => CarGroupModel.fromJson(item is Map<String, dynamic>
                ? item
                : Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    }

    return [];
  } on DioException catch (e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['message'] != null) {
      throw Exception(data['message']);
    }
    throw Exception(responseOfStatusCode(e.response?.statusCode));
  } catch (e) {
    throw Exception(e.toString());
  }
}
