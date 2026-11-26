import 'dart:convert';
import 'dart:typed_data';

class GetCompanyDriversModel {
  final List<CompanyDriverModel> drivers;

  GetCompanyDriversModel({
    required this.drivers,
  });

  factory GetCompanyDriversModel.fromJson(dynamic json) {
    List rawList = [];

    if (json is List) {
      rawList = json;
    } else if (json is Map<String, dynamic>) {
      final data = json["data"] ?? json["drivers"] ?? json["Drivers"];
      if (data is List) {
        rawList = data;
      }
    }

    return GetCompanyDriversModel(
      drivers: rawList
          .map(
            (e) => CompanyDriverModel.fromJson(
              e is Map<String, dynamic>
                  ? e
                  : Map<String, dynamic>.from(e as Map),
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
    } else if (value is Uint8List) {
      return value;
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
  final bool isActive;

  final Uint8List? image;
  final Uint8List? licenseImage;
  final Uint8List? identityImage;

  final CompanyDriverCarModel? car;
  final List<CompanyDriverCarModel> cars;

  CompanyDriverModel({
    required this.id,
    required this.companyId,
    required this.type,
    required this.name,
    required this.phone,
    required this.email,
    this.isActive = true,
    this.image,
    this.licenseImage,
    this.identityImage,
    this.car,
    this.cars = const [],
  });

  factory CompanyDriverModel.fromJson(
    Map<String, dynamic> json,
  ) {
    CompanyDriverCarModel? singleCar;
    if (json["car"] != null) {
      singleCar = CompanyDriverCarModel.fromJson(
        Map<String, dynamic>.from(json["car"]),
      );
    }

    List<CompanyDriverCarModel> carList = [];
    if (json["cars"] != null && json["cars"] is List) {
      carList = (json["cars"] as List)
          .map(
            (e) => CompanyDriverCarModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } else if (singleCar != null) {
      carList = [singleCar];
    }

    final rawActive = json["isactive"] ?? json["isActive"] ?? json["ISACTIVE"];
    final bool activeStatus = rawActive is bool ? rawActive : true;

    return CompanyDriverModel(
      id: json["id"] ?? 0,
      companyId: json["companyid"] ?? json["companyId"] ?? 0,
      type: json["type"] ?? 0,
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      isActive: activeStatus,
      image: GetCompanyDriversModel.decodeImage(json["image"]),
      licenseImage: GetCompanyDriversModel.decodeImage(
          json["licenseimage"] ?? json["licenseImage"]),
      identityImage: GetCompanyDriversModel.decodeImage(
          json["identityimage"] ?? json["identityImage"]),
      car: singleCar,
      cars: carList,
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
      id: json["id"] ?? json["ID"] ?? 0,
      brandName: json["brandname"] ?? json["brandName"] ?? "",
      brandLatinName: json["brandlatinname"] ?? json["brandLatinName"] ?? "",
      modelName: json["modelname"] ?? json["modelName"] ?? "",
      plateNo: json["plateno"] ?? json["plateNo"],
      image: GetCompanyDriversModel.decodeImage(json["image"]),
    );
  }
}
