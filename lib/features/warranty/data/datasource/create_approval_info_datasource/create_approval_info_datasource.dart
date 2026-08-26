import 'package:dio/dio.dart';
import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../../../features/warranty/data/model/warranty_model/warranty_model.dart';

Future<WarrantyModel?> createApprovalInfoFunction({
  required WarrantyModel warrantyModel,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      warrantyModel.toJson(),
      {
        'lang': 'ar',
      },
      ApiLink.createApprovalInfo,
    );

    final responseData = response.data;

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ??
            'Create approval failed',
      );
    }

    final data = responseData['data'];

    if (data is Map<String, dynamic>) {
      return WarrantyModel.fromJson(data);
    }

    // Create succeeded but API didn't return the object
    return null;
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