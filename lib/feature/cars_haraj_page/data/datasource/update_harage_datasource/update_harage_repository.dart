import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/create_update_harage_request/create_update_harage_request.dart';
import '../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<void> updateHarageFunction({
  required CreateUpdateHarageRequest createUpdateHarageRequest,
}) async {
  try {
    final String jsonString = json.encode(
      createUpdateHarageRequest.toUpdateJson(),
    );

    await Network.postDataWithBody(
      jsonString,
      ApiLink.updateHarage,
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
