import 'dart:convert';
import 'dart:typed_data';

class GetDriverDetailsModel {
  final int id;
  final int companyId;
  final String? name;
  final String? phone;
  final String? email;
  final Uint8List? image;
  final bool isActive;
  final int type;
  final Uint8List? licenseImage;
  final Uint8List? identityImage;
  final List<DriverCarModel> cars;
  final List<dynamic> serviceStats;

  GetDriverDetailsModel({
    required this.id,
    required this.companyId,
    this.name,
    this.phone,
    this.email,
    this.image,
    required this.isActive,
    required this.type,
    this.licenseImage,
    this.identityImage,
    required this.cars,
    required this.serviceStats,
  });

  factory GetDriverDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetDriverDetailsModel(
      id: json["id"] ?? 0,
      companyId: json["companyid"] ?? 0,
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      image: _decodeImage(json["image"]),
      isActive: json["isactive"] ?? false,
      type: json["type"] ?? 0,
      licenseImage: _decodeImage(json["licenseimage"]),
      identityImage: _decodeImage(json["identityimage"]),
      cars: (json["cars"] as List<dynamic>? ?? [])
          .map((e) => DriverCarModel.fromJson(e))
          .toList(),
      serviceStats: json["serviceStats"] ?? [],
    );
  }

  static Uint8List? _decodeImage(dynamic value) {
    if (value == null) return null;

    if (value is String && value.isNotEmpty) {
      try {
        return base64Decode(value);
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}

class DriverCarModel {
  final int id;
  final int releaseDate;
  final int ownerId;
  final int ownerType;
  final String? chassisNo;
  final String? plateNo;
  final String? insuranceNo;
  final Uint8List? licenceImage;
  final String? name;
  final DriverCarBrandModel? brand;
  final DriverCarModelData? model;

  DriverCarModel({
    required this.id,
    required this.releaseDate,
    required this.ownerId,
    required this.ownerType,
    this.chassisNo,
    this.plateNo,
    this.insuranceNo,
    this.licenceImage,
    this.name,
    this.brand,
    this.model,
  });

  factory DriverCarModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DriverCarModel(
      id: json["id"] ?? 0,
      releaseDate: json["releasedate"] ?? 0,
      ownerId: json["ownerid"] ?? 0,
      ownerType: json["ownertype"] ?? 0,
      chassisNo: json["chassisno"],
      plateNo: json["plateno"],
      insuranceNo: json["insuranceno"],
      licenceImage:
      GetDriverDetailsModel._decodeImage(json["licenceimage"]),
      name: json["name"],
      brand: json["brand"] != null
          ? DriverCarBrandModel.fromJson(json["brand"])
          : null,
      model: json["model"] != null
          ? DriverCarModelData.fromJson(json["model"])
          : null,
    );
  }
}

class DriverCarBrandModel {
  final int carBrandId;
  final String? brandName;
  final String? brandLatinName;
  final Uint8List? image;

  DriverCarBrandModel({
    required this.carBrandId,
    this.brandName,
    this.brandLatinName,
    this.image,
  });

  factory DriverCarBrandModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DriverCarBrandModel(
      carBrandId: json["carbrandid"] ?? 0,
      brandName: json["brandname"],
      brandLatinName: json["brandlatinname"],
      image: GetDriverDetailsModel._decodeImage(json["image"]),
    );
  }
}

class DriverCarModelData {
  final int carModelId;
  final String? modelName;
  final Uint8List? image;

  DriverCarModelData({
    required this.carModelId,
    this.modelName,
    this.image,
  });

  factory DriverCarModelData.fromJson(
      Map<String, dynamic> json,
      ) {
    return DriverCarModelData(
      carModelId: json["carmodelid"] ?? 0,
      modelName: json["modelname"],
      image: GetDriverDetailsModel._decodeImage(json["image"]),
    );
  }
}