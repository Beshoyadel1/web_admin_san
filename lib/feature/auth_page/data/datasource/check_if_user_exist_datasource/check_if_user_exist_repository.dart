import 'package:dio/dio.dart';
import '../../request/check_if_user_exist_request/check_if_user_exist_request.dart';
import '../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
Future<bool> checkIfUserExistFunction({
  required CheckIfUserExistRequest checkIfUserExistRequest,
}) async {
  try {
    final value = await Network.postDataWithBodyAndParams(
      {},
      checkIfUserExistRequest.toJson(), // params
      ApiLink.checkIfUserExist,
    );
    final body = value.data.toString().trim();
    if (body == "EmailExist") {
      AppSnackBar.showSuccess(LocaleKeys.emailExist);
      return true;
    } else {
      AppSnackBar.showError(LocaleKeys.emailNotExist);
      return false;
    }
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
    return false;
  }
}
