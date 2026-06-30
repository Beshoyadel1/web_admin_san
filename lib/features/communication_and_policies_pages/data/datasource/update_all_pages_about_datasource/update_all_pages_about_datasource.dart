import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';

Future<void> updatePageAboutFunction({
  required AboutPageModel page,
}) async {
  try {
    final jsonString = jsonEncode(
      page.toJson(),
    );

    await Network.postDataWithBody(
      jsonString,
      ApiLink.updatePageAbout,
    );
  } on DioException catch (e) {
    AppSnackBar.showError(
      responseOfStatusCode(
        e.response?.statusCode,
      ),
    );
    rethrow;
  } catch (e) {
    AppSnackBar.showError(
      e.toString(),
    );
    rethrow;
  }
}