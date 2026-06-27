import 'dart:convert';
import 'dart:typed_data';

class GetCompanyDriversModel {
  final List<CompanyDriverModel> drivers;

  GetCompanyDriversModel({
    required this.drivers,
  });

  factory GetCompanyDriversModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetCompanyDriversModel(
      drivers: (json["data"] as List? ?? [])
          .map(
            (e) => CompanyDriverModel.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
    );
  }

  static Uint8List? decodeImage(dynamic value) {
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

class CompanyDriverModel {
  final int id;
  final int companyId;
  final int type;

  final String name;
  final String phone;
  final String email;

  final Uint8List? image;
  final Uint8List? licenseImage;
  final Uint8List? identityImage;

  final CompanyDriverCarModel? car;

  CompanyDriverModel({
    required this.id,
    required this.companyId,
    required this.type,
    required this.name,
    required this.phone,
    required this.email,
    this.image,
    this.licenseImage,
    this.identityImage,
    this.car,
  });

  factory CompanyDriverModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompanyDriverModel(
      id: json["id"] ?? 0,
      companyId: json["companyid"] ?? 0,
      type: json["type"] ?? 0,
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      image: GetCompanyDriversModel.decodeImage(json["image"]),
      licenseImage:
      GetCompanyDriversModel.decodeImage(json["licenseimage"]),
      identityImage:
      GetCompanyDriversModel.decodeImage(json["identityimage"]),
      car: json["car"] == null
          ? null
          : CompanyDriverCarModel.fromJson(
        Map<String, dynamic>.from(json["car"]),
      ),
    );
  }
}

class CompanyDriverCarModel {
  final int id;
  final String brandName;
  final String brandLatinName;
  final String modelName;
  final String? plateNo;
  final Uint8List? image;

  CompanyDriverCarModel({
    required this.id,
    required this.brandName,
    required this.brandLatinName,
    required this.modelName,
    required this.plateNo,
    this.image,
  });

  factory CompanyDriverCarModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompanyDriverCarModel(
      id: json["id"] ?? 0,
      brandName: json["brandname"] ?? "",
      brandLatinName: json["brandlatinname"] ?? "",
      modelName: json["modelname"] ?? "",
      plateNo: json["plateno"],
      image: GetCompanyDriversModel.decodeImage(json["image"]),
    );
  }
}