import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/features/providers/data/request/facility_provider_request/upload_provider_work_times_request/upload_provider_work_times_request.dart';
Future<void> uploadProviderWorkTimesFunction({required UploadProviderWorkTimesRequest uploadProviderWorkTimesRequest}) async {
  try {
    String jsonString = json.encode(uploadProviderWorkTimesRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.uploadProviderWorkTimes,
    ).then((value) {
      
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}