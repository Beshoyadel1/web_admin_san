import 'package:dio/dio.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/api/dio_function/dio_controller.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/features/order_services/data/request/get_orders_request/get_orders_request.dart';
import 'package:web_admin_san/features/order_services/data/response/orders_response/orders_response.dart';

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