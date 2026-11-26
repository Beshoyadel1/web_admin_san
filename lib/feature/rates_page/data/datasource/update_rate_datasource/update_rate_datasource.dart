import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/rates_page/data/request/update_rate_request/update_rate_request.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<Map<String, dynamic>> updateRateFunction({
  required UpdateRateRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      request.toJson(),
      <String, dynamic>{},
      ApiLink.updateRate,
    );
    final data = response.data;

    if (data is! Map) {
      throw Exception("Invalid response from server");
    }

    final json = Map<String, dynamic>.from(data);

    if (json["success"] != true) {
      throw Exception(
        json["message"]?.toString() ?? "Failed to update rate",
      );
    }

    return json;
  } on DioException catch (e) {
    throw Exception(
      responseOfStatusCode(
        e.response?.statusCode,
      ),
    );
  } catch (e) {
    throw Exception(
      e.toString().replaceFirst("Exception: ", ""),
    );
  }
}
