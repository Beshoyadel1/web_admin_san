import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';

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
