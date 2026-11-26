import 'package:dio/dio.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/network.dart';
import 'package:web_admin_san/core/networking/failures.dart';
import 'package:web_admin_san/feature/orders_page/data/request/get_orders_request/get_orders_request.dart';
import 'package:web_admin_san/feature/orders_page/data/response/orders_response/orders_response.dart';

Future<OrdersResponse> getOrdersFunction({
  required GetOrdersRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getOrders,
    );

    if (response.data["success"] != true) {
      throw Exception("Request failed");
    }

    return OrdersResponse.fromJson(
      response.data["data"],
    );
  } on DioException catch (e) {
    throw Exception(
      responseOfStatusCode(
        e.response?.statusCode,
      ),
    );
  } catch (e) {
    throw Exception(
      e.toString(),
    );
  }
}
