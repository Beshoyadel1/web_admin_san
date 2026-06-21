import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/features/providers/data/request/facility_provider_request/delete_provider_work_time_request/delete_provider_work_time_request.dart';

Future<void> deleteProviderWorkTimeFunction({
  required DeleteProviderWorkTimeRequest deleteProviderWorkTimeRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteProviderWorkTimeRequest.toJson(),
        ApiLink.deleteProviderWorkTime
    );
    AppSnackBar.showSuccess(AppLanguageKeys.deleteProviderWorkTimeSuccess);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}