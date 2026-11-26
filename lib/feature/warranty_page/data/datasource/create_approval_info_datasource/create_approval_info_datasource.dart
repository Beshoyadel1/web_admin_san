import 'package:dio/dio.dart';
import '../../../../../../../../core/networking/api_link.dart';
import '../../../../../../../../core/networking/network.dart';
import '../../../../../../../../core/networking/failures.dart';
import 'package:web_admin_san/feature/warranty_page/data/model/warranty_model/warranty_model.dart';

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
        responseData['message']?.toString() ?? 'Create approval failed',
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
