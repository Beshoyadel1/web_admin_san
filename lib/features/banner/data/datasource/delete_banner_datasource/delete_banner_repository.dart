import 'package:dio/dio.dart';
import 'package:web_admin_san/features/banner/data/model/delete_banner_model/delete_banner_model.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';


Future<void> deleteBannerFunction({
  required DeleteBannerRequest deleteBannerRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteBannerRequest.toJson(),
      ApiLink.deleteBanner,
    );

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(
        e.response?.statusCode,
      )
          : e.toString(),
    );

    rethrow;
  }
}