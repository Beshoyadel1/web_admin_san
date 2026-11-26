import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/providers_page/data/request/facility_provider_request/upload_provider_work_times_request/upload_provider_work_times_request.dart';

Future<void> uploadProviderWorkTimesFunction(
    {required UploadProviderWorkTimesRequest
        uploadProviderWorkTimesRequest}) async {
  try {
    String jsonString = json.encode(uploadProviderWorkTimesRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.uploadProviderWorkTimes,
    ).then((value) {});
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
