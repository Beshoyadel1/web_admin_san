import 'dart:convert';
import 'dart:typed_data';
import '../../../../../../features/internal_services/data/model/get_provider_orders_model/service_model.dart';
import '../../../../../../features/internal_services/data/model/get_provider_orders_model/service_package_model.dart';

class OrderModel {
  final int? id;
  final int? userId;
  final String? username;
  final int? userType;
  final int? orderStatus;
  final String? orderDate;
  final num? totalPrice;
  final int? providerId;
  final String? providerName;
  final String? providerLatinName;
  final Uint8List? providerImage;
  final String? branchName;
  final String? branchLatinName;
  final int? branchId;
  final List<ServiceModel>? services;
  final List<dynamic>? provServices;
  final List<ServicePackageModel>? servicePackages;
  final dynamic car;
  // UserOrderModel fields
  final String? notes;
  final String? serviceName;
  final String? serviceLatinName;

  OrderModel({
    this.id,
    this.userId,
    this.username,
    this.userType,
    this.orderStatus,
    this.orderDate,
    this.totalPrice,
    this.providerId,
    this.providerName,
    this.providerLatinName,
    this.providerImage,
    this.branchName,
    this.branchLatinName,
    this.branchId,
    this.services,
    this.provServices,
    this.servicePackages,
    this.car,

    this.notes,
    this.serviceName,
    this.serviceLatinName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      // old api
      id: json['id'] ?? json['orderId'] ?? 0,

      userId: json['userid'] ?? 0,
      username: json['username'] ?? '',
      userType: json['usertype'] ?? 0,

      orderStatus: json['orderstatus'] ?? json['status'] ?? 0,

      orderDate: json['orderdate'] ?? json['date'] ?? '',

      totalPrice: json['totalprice'] ??
          json['totalPrice'] ??
          0,

      providerId: json['provid'] ??
          json['providerId'] ??
          0,

      providerName: json['provname'] ??
          json['providerName'] ??
          '',

      providerLatinName: json['provlatinname'] ??
          json['providerLatinName'] ??
          '',

      providerImage:
      json['provimage'] != null &&
          json['provimage'].toString().isNotEmpty
          ? base64Decode(json['provimage'])
          : json['providerImage'] != null &&
          json['providerImage'].toString().isNotEmpty
          ? base64Decode(json['providerImage'])
          : null,

      branchId: json['branchid'] ?? 0,
      branchName: json['branchname'] ?? '',
      branchLatinName: json['branchlatinname'] ?? '',

      notes: json['notes'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceLatinName: json['serviceLatinName'] ?? '',

      services: (json['services'] as List<dynamic>? ?? [])
          .map((e) => ServiceModel.fromJson(e))
          .toList(),

      provServices: json['provServices'] ?? [],

      servicePackages:
      (json['servicePackages'] as List<dynamic>? ?? [])
          .map((e) => ServicePackageModel.fromJson(e))
          .toList(),

      car: json['car'],
    );
  }
}