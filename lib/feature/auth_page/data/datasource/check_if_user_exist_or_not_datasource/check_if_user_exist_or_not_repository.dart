import 'package:dio/dio.dart';

import 'package:web_admin_san/feature/auth_page/data/model/check_if_user_exist_or_not_model/check_if_user_exist_or_not_model.dart';
import '../../request/check_if_user_exist_or_not_request/check_if_user_exist_or_not_request.dart';
import '../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<List<CheckIfUserExistOrNotModel>?> checkIfUserExistOrNotFunction({
  required CheckIfUserExistOrNotRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.checkIfUserExistOrNot,
    );

    final responseData = response.data as Map<String, dynamic>;

    final bool success = responseData['success'] == true;

    if (!success) {
      return [];
    }
    final List<dynamic> data = (responseData['data'] as List?) ?? [];

    return data
        .map(
          (e) => CheckIfUserExistOrNotModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(
              e.response?.statusCode,
            )
          : e.toString(),
    );

    return [];
  }
}
