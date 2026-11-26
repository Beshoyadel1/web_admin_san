import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/providers_page/data/request/facility_provider_request/delete_provider_work_time_request/delete_provider_work_time_request.dart';

Future<void> deleteProviderWorkTimeFunction({
  required DeleteProviderWorkTimeRequest deleteProviderWorkTimeRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams({},
        deleteProviderWorkTimeRequest.toJson(), ApiLink.deleteProviderWorkTime);
    AppSnackBar.showSuccess(LocaleKeys.deleteProviderWorkTimeSuccess);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
