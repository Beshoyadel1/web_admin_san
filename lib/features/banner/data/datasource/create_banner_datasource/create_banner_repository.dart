import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_admin_san/features/banner/data/model/get_banners_models/banner_model.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';

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
