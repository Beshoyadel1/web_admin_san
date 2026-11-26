import 'package:dio/dio.dart';
import '../../../../../../../../core/networking/api_link.dart';
import '../../../../../../../../core/networking/network.dart';
import '../../../../../../../../core/networking/failures.dart';
import 'package:web_admin_san/feature/warranty_page/data/model/warranty_model/warranty_model.dart';
import 'package:web_admin_san/feature/warranty_page/data/request/get_approval_info_by_id_request/get_approval_info_by_id_request.dart';

Future<WarrantyModel> getApprovalInfoByIdFunction({
  required GetApprovalInfoByIdRequest request,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getApprovalInfoById,
    );

    final responseData = response.data;

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ?? 'Something went wrong',
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
