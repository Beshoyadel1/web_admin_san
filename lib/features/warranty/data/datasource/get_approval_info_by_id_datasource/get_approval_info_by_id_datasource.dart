import 'package:dio/dio.dart';
import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../../../features/warranty/data/model/warranty_model/warranty_model.dart';
import '../../../../../../../../features/warranty/data/request/get_approval_info_by_id_request/get_approval_info_by_id_request.dart';

Future<WarrantyModel> getApprovalInfoByIdFunction({
  required GetApprovalInfoByIdRequest request,
}) async {
  try {
    final response =
    await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getApprovalInfoById,
    );

    final responseData = response.data;

    final bool success =
        responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ??
            'Something went wrong',
      );
    }

    return WarrantyModel.fromJson(
      responseData['data'],
    );
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