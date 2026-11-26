import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/get_banners_models/banner_model.dart';

import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';

Future<List<BannerModel>> getBannersFunction() async {
  try {
    final response = await Network.postData(
      ApiLink.getBanners,
    );

    final json = response.data as Map<String, dynamic>;

    if (json['success'] == true && json['data'] != null) {
      return (json['data'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();
    }

    return [];
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );

    return [];
  }
}
