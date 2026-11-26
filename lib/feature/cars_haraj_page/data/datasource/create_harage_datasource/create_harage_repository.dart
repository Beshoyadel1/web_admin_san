import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../../../../core/networking/failures.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/create_update_harage_request/create_update_harage_request.dart';
import '../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../core/networking/network.dart';

Future<void> createHarageFunction({
  required CreateUpdateHarageRequest createUpdateHarageRequest,
}) async {
  try {
    final jsonString = json.encode(
      createUpdateHarageRequest.toCreateJson(),
    );

    await Network.postDataWithBody(
      jsonString,
      ApiLink.createHarage,
    );
  } catch (e) {
    debugPrint('CREATE ERROR: $e');

    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    rethrow;
  }
}
