import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';

Future<Response> addBranchFunction({
  required Map<String, dynamic> body,
}) async {
  try {
    final response = await Network.postDataWithBody(
      body,
      ApiLink.addBranch,
    );

    return response;
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
