import 'package:dio/dio.dart';
import 'package:web_admin_san/features/banner/data/model/get_banners_models/banner_model.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';

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