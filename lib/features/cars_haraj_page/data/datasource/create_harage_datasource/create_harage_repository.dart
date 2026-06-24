import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../features/cars_haraj_page/data/request/update_harage_request/update_harage_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/language/language_constant.dart';


Future<void> createHarageFunction({
  required UpdateHarageRequest updateHarageRequest,
}) async {
  try {
    String jsonString = jsonEncode(updateHarageRequest.toJson());

    print("REQUEST:");
    print(jsonString);

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.createHarage,
    );

    print("RESPONSE:");
    print(response.data);

    AppSnackBar.showSuccess(
      AppLanguageKeys.createHarageSuccessfully,
    );
  } catch (e) {
    print(e);
    rethrow;
  }
}

