import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';

Future<List<AboutPageModel>> getAllPagesAboutFunction() async {
  try {
    final response = await Network.getData(
      ApiLink.getAllPagesAbout,
    );

    final json = response.data as Map<String, dynamic>;

    if (json["success"] == true && json["data"] != null) {
      return (json["data"] as List)
          .map((e) => AboutPageModel.fromJson(e))
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