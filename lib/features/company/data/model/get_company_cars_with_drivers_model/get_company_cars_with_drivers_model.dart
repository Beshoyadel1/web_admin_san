import 'dart:convert';
import 'dart:typed_data';
class GetCompanyCarsWithDriversModel {
  final List<GetCompanyCarWithDriver> cars;

  GetCompanyCarsWithDriversModel({
    required this.cars,
  });

  factory GetCompanyCarsWithDriversModel.fromJson(List<dynamic> json) {
    return GetCompanyCarsWithDriversModel(
      cars: json
          .map((e) => GetCompanyCarWithDriver.fromJson(e))
          .toList(),
    );
  }
}
class GetCompanyCarWithDriver {
  final int carId;
  final String? plateNo;
  final CarBrandModel? brand;
  final CarModelData? model;
  final bool isHasDriver;

  GetCompanyCarWithDriver({
    required this.carId,
    required this.plateNo,
    required this.brand,
    required this.model,
    required this.isHasDriver,
  });

  factory GetCompanyCarWithDriver.fromJson(Map<String, dynamic> json) {
    return GetCompanyCarWithDriver(
      carId: json['carId'] ?? 0,
      plateNo: json['plateno'],
      brand: json['brand'] != null
          ? CarBrandModel.fromJson(json['brand'])
          : null,
      model: json['model'] != null
          ? CarModelData.fromJson(json['model'])
          : null,
      isHasDriver: json['isHasDriver'] ?? false,
    );
  }
}

class CarBrandModel {
  final int brandId;
  final String? name;
  final String? latinName;

  CarBrandModel({
    required this.brandId,
    this.name,
    this.latinName,
  });

  factory CarBrandModel.fromJson(Map<String, dynamic> json) {
    return CarBrandModel(
      brandId: json['brandId'] ?? 0,
      name: json['name'],
      latinName: json['latinName'],
    );
  }
}

class CarModelData {
  final int modelId;
  final String? name;
  final Uint8List? image;

  CarModelData({
    required this.modelId,
    this.name,
    this.image,
  });

  factory CarModelData.fromJson(Map<String, dynamic> json) {
    return CarModelData(
      modelId: json['modelId'] ?? 0,
      name: json['name'],
      image: _decodeImage(json['image']),
    );
  }

  static Uint8List? _decodeImage(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      return base64Decode(value);
    }
    return null;
  }
}