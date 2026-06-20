import 'dart:convert';
import 'dart:typed_data';

class ProviderDetailsRatesModel {
  final ProviderModel? provider;
  final int rateCount;
  final double averageRate;
  final List<ServiceRateModel> rates;

  ProviderDetailsRatesModel({
    this.provider,
    required this.rateCount,
    required this.averageRate,
    required this.rates,
  });

  factory ProviderDetailsRatesModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProviderDetailsRatesModel(
      provider: json["provider"] != null
          ? ProviderModel.fromJson(
        json["provider"],
      )
          : null,
      rateCount: json["rateCount"] ?? 0,
      averageRate:
      (json["averageRate"] ?? 0).toDouble(),
      rates: (json["rates"] as List?)
          ?.map(
            (e) =>
            ServiceRateModel.fromJson(e),
      )
          .toList() ??
          [],
    );
  }
}

class ProviderModel {
  final int id;
  final String name;
  final String latinName;
  final Uint8List? image;

  ProviderModel({
    required this.id,
    required this.name,
    required this.latinName,
    this.image,
  });

  factory ProviderModel.fromJson(
      Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      latinName: json['latinname'] ?? '',
      image: json['image'] != null
          ? base64Decode(json['image'])
          : null,
    );
  }
}

class ServiceRateModel {
  final int id;
  final int parentId;
  final String name;
  final String latinName;
  final Uint8List? image;
  final List<RateModel> rates;

  ServiceRateModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.latinName,
    this.image,
    required this.rates,
  });

  factory ServiceRateModel.fromJson(
      Map<String, dynamic> json) {
    return ServiceRateModel(
      id: json['id'] ?? 0,
      parentId: json['parentid'] ?? 0,
      name: json['name'] ?? '',
      latinName: json['latinname'] ?? '',
      image: json['image'] != null
          ? base64Decode(json['image'])
          : null,
      rates: (json['rates'] as List?)
          ?.map(
            (e) => RateModel.fromJson(e),
      )
          .toList() ??
          [],
    );
  }
}

class RateModel {
  final String username;
  final Uint8List? userImage;
  final int id;
  final int orderId;
  final int providerId;
  final int userId;
  final int userType;
  final String? message;
  final double rate;
  final int serviceId;
  final bool isEdited;

  RateModel({
    required this.username,
    this.userImage,
    required this.id,
    required this.orderId,
    required this.providerId,
    required this.userId,
    required this.userType,
    this.message,
    required this.rate,
    required this.serviceId,
    required this.isEdited,
  });

  factory RateModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RateModel(
      username: json['username'] ?? '',
      userImage: json['userimage'] != null
          ? base64Decode(json['userimage'])
          : null,
      id: json['id'] ?? 0,
      orderId: json['orderid'] ?? 0,
      providerId: json['provid'] ?? 0,
      userId: json['userid'] ?? 0,
      userType: json['usertype'] ?? 0,
      message: json['message'],
      rate: (json['rate'] ?? 0).toDouble(),
      serviceId: json['serviceid'] ?? 0,
      isEdited: json['isedited'] ?? false,
    );
  }
}