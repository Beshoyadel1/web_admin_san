import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/providers/data/model/facility_provider_model/get_provider_branches_model/provider_branch_model.dart';
import 'package:web_admin_san/features/providers/data/request/facility_provider_request/get_provider_branches_request/get_provider_branches_request.dart';


Future<List<ProviderBranchModel>>
getProviderBranchesFunction({
  required GetProviderBranchesRequest
  getProviderBranchesRequest,
}) async {

  try {

    final response =
    await Network.getDataWithBodyAndParams(
      {},
      getProviderBranchesRequest.toJson(),

      ApiLink.getProviderBranches,
    );

    final responseData =
        response.data;

    final bool success =
        responseData["success"] ?? false;

    if (!success) {

      throw Exception(

        responseData["message"] ??

            "Something went wrong",
      );
    }

    final List<dynamic> data =
        responseData["data"] ?? [];

    return data
        .map(
          (e) =>
          ProviderBranchModel
              .fromJson(e),
    )
        .toList();

  } catch (e) {

    if (e is DioException) {

      final data =
          e.response?.data;

      if (data
      is Map<String, dynamic>) {

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

    } else {

      throw Exception(
        e.toString(),
      );
    }
  }
}