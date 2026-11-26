import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_all_companies_model/get_all_companies_model.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_all_companies_request/get_all_companies_request.dart';

Future<GetAllCompaniesModel> getAllCompaniesProviders({
  required GetAllCompaniesRequest request,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getAllCompanies,
    );

    final responseData = response.data;

    final bool success = responseData["success"] ?? false;

    //print("Data: ${responseData["data"]}");
    if (!success) {
      throw Exception(
        responseData["message"] ?? "Something went wrong",
      );
    }
    return GetAllCompaniesModel.fromJson(
      responseData["data"],
    );
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data["message"] ??
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
