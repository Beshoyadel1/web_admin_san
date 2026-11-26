import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/get_banners_models/banner_model.dart';

import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';

Future<void> createBannerFunction({
  required BannerModel bannerModel,
}) async {
  try {
    String jsonString = jsonEncode(
      bannerModel.toJson(),
    );

    await Network.postDataWithBody(
      jsonString,
      ApiLink.createBanner,
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
