import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/delete_harage_request/delete_harage_request.dart';
import '../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<void> deleteHarageFunction({
  required DeleteHarageRequest deleteHarageRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteHarageRequest.toJson(), // params
      ApiLink.deleteHarage,
    );
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
