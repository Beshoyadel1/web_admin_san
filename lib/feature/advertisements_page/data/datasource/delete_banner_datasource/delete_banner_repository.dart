import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/delete_banner_model/delete_banner_model.dart';

import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';

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
