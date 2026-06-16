import 'package:web_admin_san/features/internal_services/data/model/get_provider_orders_model/order_model.dart';

class OrdersResponse {
  final List<OrderModel> orders;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  OrdersResponse({
    required this.orders,
    required this.currentPage,
    required this.pageCount,
    required this.totalCount,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      orders: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OrderModel.fromJson(e))
          .toList(),
      currentPage: json['currentPage'] ?? 1,
      pageCount: json['pageCount'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
    );
  }
}