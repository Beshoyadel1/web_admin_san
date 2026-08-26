import 'package:dio/dio.dart';
import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../../../features/warranty/data/model/warranty_model/warranty_model.dart';

Future<WarrantyModel> updateApprovalInfoFunction({
  required WarrantyModel warrantyModel,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      warrantyModel.toUpdateJson(),
      {
        'lang': 'ar',
      },
      ApiLink.updateApprovalInfo,
    );

    final responseData = response.data;

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ??
            'Update approval failed',
      );
    }

    final data = responseData['data'];

    if (data == null) {
      // If API doesn't return updated object,
      // return the object we already sent.
      return warrantyModel;
    }

    return WarrantyModel.fromJson(
      Map<String, dynamic>.from(data),
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