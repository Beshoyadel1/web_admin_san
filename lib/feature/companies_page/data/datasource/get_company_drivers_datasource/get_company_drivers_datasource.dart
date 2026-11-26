import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_drivers_model/get_company_drivers_model.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_company_drivers_request/get_company_drivers_request.dart';

Future<GetCompanyDriversModel> getCompanyDriversFunction({
  required GetCompanyDriversRequest request,
}) async {
  try {
    final response = await Network.getDataWithParams(
      request.toQueryParams(),
      ApiLink.getCompanyDrivers,
    );

    final responseData = response.data;

    if (responseData is List) {
      return GetCompanyDriversModel.fromJson(responseData);
    }

    if (responseData is Map<String, dynamic>) {
      final bool? success = responseData["success"];
      if (success == false) {
        throw Exception(
          responseData["message"] ?? "Failed to load company drivers",
        );
      }
      return GetCompanyDriversModel.fromJson(responseData);
    }

    return GetCompanyDriversModel(drivers: []);
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic> && data["message"] != null) {
      throw Exception(data["message"]);
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
