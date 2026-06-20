import 'dart:convert';
import 'dart:typed_data';

class ProviderRateModel {
  final ProviderModel provider;
  final int rateCount;
  final double averageRate;

  ProviderRateModel({
    required this.provider,
    required this.rateCount,
    required this.averageRate,
  });

  factory ProviderRateModel.fromJson(Map<String, dynamic> json) {
    return ProviderRateModel(
      provider: ProviderModel.fromJson(json['provider'] ?? {}),
      rateCount: json['rateCount'] ?? 0,
      averageRate: (json['averageRate'] ?? 0).toDouble(),
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

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
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