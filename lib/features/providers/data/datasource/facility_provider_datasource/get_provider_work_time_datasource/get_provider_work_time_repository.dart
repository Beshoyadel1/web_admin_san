import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/providers/data/model/facility_provider_model/upload_provider_work_times_model/work_time_model.dart';
import 'package:web_admin_san/features/providers/data/request/facility_provider_request/get_provider_work_time_request/get_provider_work_time_request.dart';

Future<List<WorkTimeModel>>
getProviderWorkTimeFunction({
  required GetProviderWorkTimeRequest
  getProviderWorkTimeRequest,
}) async {

  try {

    final response =
    await Network.postDataWithBodyAndParams(

      {},

      getProviderWorkTimeRequest.toJson(),

      ApiLink.getProviderWorkTime,
    );

    final responseData =
        response.data;

    final bool success =
        responseData["success"] ?? false;

    /// 👇 لو مفيش بيانات
    if (!success) {

      return [];
    }

    final List<dynamic> data =
        (responseData["data"] as List?) ?? [];

    return data.map((e) {

      return WorkTimeModel(

        worktimeid:
        e["worktimeid"],

        provid:
        e["provid"],

        sat:
        e["sat"],

        sun:
        e["sun"],

        mon:
        e["mon"],

        tue:
        e["tue"],

        wed:
        e["wed"],

        thr:
        e["thr"],

        fri:
        e["fri"],

        fromTime:
        e["fromtime"],

        toTime:
        e["totime"],
      );

    }).toList();

  } catch (e) {

    if (e is DioException) {

      final data =
          e.response?.data;

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
    }

    throw Exception(
      e.toString(),
    );
  }
}