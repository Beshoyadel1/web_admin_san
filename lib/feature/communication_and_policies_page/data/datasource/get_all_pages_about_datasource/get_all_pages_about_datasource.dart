import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';

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
