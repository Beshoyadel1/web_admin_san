import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';

class DeliveryOrderPaginatedResponse {
  final List<OrderModel> data;
  final int totalCount;
  final int pageCount;
  final int currentPage;

  const DeliveryOrderPaginatedResponse({
    required this.data,
    required this.totalCount,
    required this.pageCount,
    required this.currentPage,
  });

  factory DeliveryOrderPaginatedResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] ?? json['Data'] ?? [];
    final list = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map(OrderModel.fromJson)
            .toList()
        : <OrderModel>[];

    final rawTotal = json['totalCount'] ?? json['TotalCount'] ?? 0;
    final rawPageCount = json['pageCount'] ?? json['PageCount'] ?? 1;
    final rawCurrent = json['currentPage'] ?? json['CurrentPage'] ?? 1;

    return DeliveryOrderPaginatedResponse(
      data: list,
      totalCount:
          (rawTotal is num) ? rawTotal.toInt() : int.tryParse('$rawTotal') ?? 0,
      pageCount: (rawPageCount is num)
          ? rawPageCount.toInt()
          : int.tryParse('$rawPageCount') ?? 1,
      currentPage: (rawCurrent is num)
          ? rawCurrent.toInt()
          : int.tryParse('$rawCurrent') ?? 1,
    );
  }
}

class DeliveryOrderItemModel {
  final int orderId;
  final int providerId;
  final String providerName;
  final String customerName;
  final String customerPhone;
  final int? deliveryOrderId;
  final String deliveryOrderStatus;
  final String? mandoobName;
  final String? mandoobPhone;
  final double deliveryFee;
  final DateTime? mandoobAcceptDate;
  final DateTime? mandoobReceiveDate;
  final DateTime? mandoobDeliverDate;
  final DateTime? orderDate;
  final double totalPrice;
  final String nationalAddress;

  const DeliveryOrderItemModel({
    required this.orderId,
    required this.providerId,
    required this.providerName,
    required this.customerName,
    required this.customerPhone,
    this.deliveryOrderId,
    required this.deliveryOrderStatus,
    this.mandoobName,
    this.mandoobPhone,
    required this.deliveryFee,
    this.mandoobAcceptDate,
    this.mandoobReceiveDate,
    this.mandoobDeliverDate,
    this.orderDate,
    required this.totalPrice,
    required this.nationalAddress,
  });

  factory DeliveryOrderItemModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderItemModel(
      orderId: (json['orderId'] ?? json['OrderId'] ?? 0) as int,
      providerId: (json['providerId'] ?? json['ProviderId'] ?? 0) as int,
      providerName:
          (json['providerName'] ?? json['ProviderName'] ?? '').toString(),
      customerName:
          (json['customerName'] ?? json['CustomerName'] ?? '').toString(),
      customerPhone:
          (json['customerPhone'] ?? json['CustomerPhone'] ?? '').toString(),
      deliveryOrderId:
          (json['deliveryOrderId'] ?? json['DeliveryOrderId']) as int?,
      deliveryOrderStatus: (json['deliveryOrderStatus'] ??
              json['DeliveryOrderStatus'] ??
              'newOrder')
          .toString(),
      mandoobName: (json['mandoobName'] ?? json['MandoobName'])?.toString(),
      mandoobPhone: (json['mandoobPhone'] ?? json['MandoobPhone'])?.toString(),
      deliveryFee: ((json['deliveryFee'] ?? json['DeliveryFee'] ?? 0.0) as num)
          .toDouble(),
      mandoobAcceptDate: json['mandoobAcceptDate'] != null
          ? DateTime.tryParse(json['mandoobAcceptDate'].toString())?.toLocal()
          : (json['MandoobAcceptDate'] != null
              ? DateTime.tryParse(json['MandoobAcceptDate'].toString())?.toLocal()
              : null),
      mandoobReceiveDate: json['mandoobReceiveDate'] != null
          ? DateTime.tryParse(json['mandoobReceiveDate'].toString())?.toLocal()
          : (json['MandoobReceiveDate'] != null
              ? DateTime.tryParse(json['MandoobReceiveDate'].toString())?.toLocal()
              : null),
      mandoobDeliverDate: json['mandoobDeliverDate'] != null
          ? DateTime.tryParse(json['mandoobDeliverDate'].toString())?.toLocal()
          : (json['MandoobDeliverDate'] != null
              ? DateTime.tryParse(json['MandoobDeliverDate'].toString())?.toLocal()
              : null),
      orderDate: json['orderDate'] != null
          ? DateTime.tryParse(json['orderDate'].toString())?.toLocal()
          : (json['OrderDate'] != null
              ? DateTime.tryParse(json['OrderDate'].toString())?.toLocal()
              : null),
      totalPrice:
          ((json['totalPrice'] ?? json['TotalPrice'] ?? 0.0) as num).toDouble(),
      nationalAddress:
          (json['nationalAddress'] ?? json['NationalAddress'] ?? '').toString(),
    );
  }
}
