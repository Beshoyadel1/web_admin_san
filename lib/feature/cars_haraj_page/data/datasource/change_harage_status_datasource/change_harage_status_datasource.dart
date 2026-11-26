import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/networking/network.dart';
import '../../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/change_harage_status_request/change_harage_status_request.dart';

Future<void> changeHarageStatusFunction({
  required ChangeHarageStatusRequest request,
}) async {
  try {
    final jsonString = json.encode(
      request.toJson(),
    );

    await Network.postDataWithBody(
      jsonString,
      ApiLink.changeHarageStatus,
    );
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    rethrow;
  }
}
