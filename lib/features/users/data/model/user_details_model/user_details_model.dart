import 'dart:convert';
import 'dart:typed_data';
import 'package:web_admin_san/features/internal_services/data/model/get_provider_orders_model/order_model.dart';

class UserDetailsResponse {
  final UserInfoModel userInfo;
  final List<UserCarModel> cars;
  final List<OrderModel> orders;

  UserDetailsResponse({
    required this.userInfo,
    required this.cars,
    required this.orders,
  });

  factory UserDetailsResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserDetailsResponse(
      userInfo: UserInfoModel.fromJson(
        Map<String, dynamic>.from(
          json['userInfo'] ?? {},
        ),
      ),
      cars: (json['cars'] as List?)
          ?.map(
            (e) => UserCarModel.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList() ??
          [],
      orders: (json['orders'] as List?)
          ?.map(
            (e) => OrderModel.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList() ??
          [],
    );
  }
}

class UserInfoModel {
  final int userId;
  final String userName;
  final String phone;
  final String email;
  final int gender;
  final int age;
  final String nationality;
  final String? nationalAddress;
  final DateTime? joinDate;
  final Uint8List? image;
  final bool isActive;
  final int? defaultCarId;

  UserInfoModel({
    required this.userId,
    required this.userName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.age,
    required this.nationality,
    this.nationalAddress,
    this.joinDate,
    this.image,
    required this.isActive,
    this.defaultCarId,
  });

  factory UserInfoModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserInfoModel(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? 0,
      age: json['age'] ?? 0,
      nationality: json['nationality'] ?? '',
      nationalAddress: json['nationalAddress'],
      joinDate: json['joinDate'] != null
          ? DateTime.tryParse(json['joinDate'])
          : null,
      image: json['image'] != null &&
          json['image'].toString().isNotEmpty
          ? base64Decode(json['image'])
          : null,
      isActive: json['isActive'] ?? false,
      defaultCarId: json['defaultCarId'],
    );
  }
}

class UserCarModel {
  final int carId;
  final String name;
  final String plateNo;
  final String chassisNo;
  final String insuranceNo;
  final int brandId;
  final String brandName;
  final String brandLatinName;
  final Uint8List? brandImage;
  final int modelId;
  final String modelName;
  final Uint8List? modelImage;
  final int releaseDate;
  final bool isDefault;
  final bool isActive;

  UserCarModel({
    required this.carId,
    required this.name,
    required this.plateNo,
    required this.chassisNo,
    required this.insuranceNo,
    required this.brandId,
    required this.brandName,
    required this.brandLatinName,
    this.brandImage,
    required this.modelId,
    required this.modelName,
    this.modelImage,
    required this.releaseDate,
    required this.isDefault,
    required this.isActive,
  });

  factory UserCarModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserCarModel(
      carId: json['carId'] ?? 0,
      name: json['name'] ?? '',
      plateNo: json['plateNo'] ?? '',
      chassisNo: json['chassisNo'] ?? '',
      insuranceNo: json['insuranceNo'] ?? '',
      brandId: json['brandId'] ?? 0,
      brandName: json['brandName'] ?? '',
      brandLatinName: json['brandLatinName'] ?? '',
      brandImage: json['brandImage'] != null &&
          json['brandImage'].toString().isNotEmpty
          ? base64Decode(json['brandImage'])
          : null,

      modelImage: json['modelImage'] != null &&
          json['modelImage'].toString().isNotEmpty
          ? base64Decode(json['modelImage'])
          : null,
      modelId: json['modelId'] ?? 0,
      modelName: json['modelName'] ?? '',
      releaseDate: json['releaseDate'] ?? 0,
      isDefault: json['isDefault'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }
}

class UserOrderModel {
  final int orderId;
  final int providerId;
  final String providerName;
  final String providerLatinName;
  final Uint8List? providerImage;
  final DateTime? date;
  final int status;
  final double totalPrice;
  final String notes;
  final String serviceName;
  final String serviceLatinName;

  UserOrderModel({
    required this.orderId,
    required this.providerId,
    required this.providerName,
    required this.providerLatinName,
    this.providerImage,
    this.date,
    required this.status,
    required this.totalPrice,
    required this.notes,
    required this.serviceName,
    required this.serviceLatinName,
  });

  factory UserOrderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserOrderModel(
      orderId: json['orderId'] ?? 0,
      providerId: json['providerId'] ?? 0,
      providerName: json['providerName'] ?? '',
      providerLatinName: json['providerLatinName'] ?? '',
      providerImage: json['providerImage'] != null &&
          json['providerImage'].toString().isNotEmpty
          ? base64Decode(json['providerImage'])
          : null,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'])
          : null,
      status: json['status'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceLatinName: json['serviceLatinName'] ?? '',
    );
  }
}