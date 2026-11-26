import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_harage_chat_model/get_harage_chat_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/request/get_harage_chat_request/get_harage_chat_request.dart';
import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../../../../core/networking/failures.dart';

Future<GetHarageChatResponse?> getHarageChatFunction({
  required GetHarageChatRequest getHarageChatRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      getHarageChatRequest.toJson(),
      getHarageChatRequest.toJson(),
      ApiLink.getHarageChat,
    );

    final responseData = response.data;

    final bool success = responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ?? 'Something went wrong',
      );
    }

    return GetHarageChatResponse.fromJson(
      responseData,
    );
  } catch (e) {
    if (e is DioException) {
      throw Exception(
        responseOfStatusCode(
          e.response?.statusCode,
        ),
      );
    }

    rethrow;
  }
}
