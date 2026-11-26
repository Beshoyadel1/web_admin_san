import 'dart:convert';
import 'dart:typed_data';

class CarGroupModel {
  final int? id;
  final String? name;
  final int? companyId;
  final String? companyName;
  final String? companyPhone;
  final List<CarInfo> cars;

  const CarGroupModel({
    this.id,
    this.name,
    this.companyId,
    this.companyName,
    this.companyPhone,
    this.cars = const [],
  });

  factory CarGroupModel.fromJson(Map<String, dynamic> json) {
    final rawCars = json['cars'] ?? json['Cars'];
    final List<CarInfo> parsedCars = [];

    if (rawCars is List) {
      for (final item in rawCars) {
        if (item is Map<String, dynamic>) {
          parsedCars.add(CarInfo.fromJson(item));
        } else if (item is Map) {
          parsedCars.add(CarInfo.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return CarGroupModel(
      id: json['id'] ?? json['ID'],
      name: json['name'] ?? json['NAME'],
      companyId: json['companyid'] ?? json['companyId'] ?? json['COMPANYID'],
      companyName:
          json['companyName'] ?? json['companyname'] ?? json['CompanyName'],
      companyPhone:
          json['companyPhone'] ?? json['companyphone'] ?? json['CompanyPhone'],
      cars: parsedCars,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyid': companyId,
      'companyName': companyName,
      'companyPhone': companyPhone,
      'cars': cars.map((c) => c.toJson()).toList(),
    };
  }
}

class DriverSimpleInfo {
  final int? id;
  final String? name;

  const DriverSimpleInfo({this.id, this.name});

  factory DriverSimpleInfo.fromJson(Map<String, dynamic> json) {
    return DriverSimpleInfo(
      id: json['id'] ?? json['Id'] ?? json['ID'],
      name: json['name'] ?? json['Name'] ?? json['NAME'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CarInfo {
  final int? id;
  final int? releaseDate;
  final int? ownerId;
  final int? ownerType;
  final String? chassisNo;
  final String? plateNo;
  final String? insuranceNo;
  final Uint8List? licenceImage;
  final String? name;
  final CarBrandInfo? brand;
  final CarModelInfo? model;
  final Uint8List? image;
  final double? totalPrice;
  final int? approvalStatus;
  final String? rejectionReason;
  final bool? isActive;
  final bool? hasPendingUpdate;
  final DriverSimpleInfo? driver;

  const CarInfo({
    this.id,
    this.releaseDate,
    this.ownerId,
    this.ownerType,
    this.chassisNo,
    this.plateNo,
    this.insuranceNo,
    this.licenceImage,
    this.name,
    this.brand,
    this.model,
    this.image,
    this.totalPrice,
    this.approvalStatus = 2,
    this.rejectionReason,
    this.isActive = true,
    this.hasPendingUpdate = false,
    this.driver,
  });

  bool get isApproved => (approvalStatus ?? 2) == 2 && (isActive ?? true);
  bool get isPending => (approvalStatus ?? 2) == 1;
  bool get isRejected => (approvalStatus ?? 2) == 3;

  factory CarInfo.fromJson(Map<String, dynamic> json) {
    final rawRelease =
        json['releasedate'] ?? json['releaseDate'] ?? json['RELEASEDATE'];
    final releaseDateVal = rawRelease is int
        ? rawRelease
        : int.tryParse(rawRelease?.toString() ?? '');

    final rawLicence =
        json['licenceimage'] ?? json['licenceImage'] ?? json['LICENCEIMAGE'];
    Uint8List? parsedLicence;
    if (rawLicence is String && rawLicence.isNotEmpty) {
      try {
        parsedLicence = base64Decode(rawLicence);
      } catch (_) {}
    } else if (rawLicence is Uint8List) {
      parsedLicence = rawLicence;
    }

    final rawImg = json['image'] ?? json['Image'] ?? json['IMAGE'];
    Uint8List? parsedImage;
    if (rawImg is String && rawImg.isNotEmpty) {
      try {
        parsedImage = base64Decode(rawImg);
      } catch (_) {}
    } else if (rawImg is Uint8List) {
      parsedImage = rawImg;
    }

    final brandData = json['brand'] ?? json['Brand'];
    CarBrandInfo? parsedBrand;
    if (brandData is Map<String, dynamic>) {
      parsedBrand = CarBrandInfo.fromJson(brandData);
    } else if (brandData is Map) {
      parsedBrand = CarBrandInfo.fromJson(Map<String, dynamic>.from(brandData));
    }

    final modelData = json['model'] ?? json['Model'];
    CarModelInfo? parsedModel;
    if (modelData is Map<String, dynamic>) {
      parsedModel = CarModelInfo.fromJson(modelData);
    } else if (modelData is Map) {
      parsedModel = CarModelInfo.fromJson(Map<String, dynamic>.from(modelData));
    }

    final rawPrice =
        json['totalprice'] ?? json['totalPrice'] ?? json['TOTALPRICE'];
    final priceVal = rawPrice is num ? rawPrice.toDouble() : null;

    final rawApprovalStatus = json['approvalstatus'] ??
        json['approvalStatus'] ??
        json['APPROVALSTATUS'];
    final approvalStatusVal = rawApprovalStatus is int
        ? rawApprovalStatus
        : int.tryParse(rawApprovalStatus?.toString() ?? '') ?? 2;

    final rejectionReasonVal = (json['rejectionreason'] ??
            json['rejectionReason'] ??
            json['REJECTIONREASON'])
        ?.toString();

    final rawIsActive =
        json['isactive'] ?? json['isActive'] ?? json['ISACTIVE'];
    final isActiveVal = rawIsActive is bool
        ? rawIsActive
        : (rawIsActive != null
            ? (rawIsActive.toString().toLowerCase() == 'true' ||
                rawIsActive == 1)
            : true);

    final rawPendingUpdate = json['haspendingupdate'] ??
        json['hasPendingUpdate'] ??
        json['HASPENDINGUPDATE'];
    final hasPendingUpdateVal = rawPendingUpdate is bool
        ? rawPendingUpdate
        : (rawPendingUpdate != null
            ? (rawPendingUpdate.toString().toLowerCase() == 'true' ||
                rawPendingUpdate == 1)
            : false);

    final driverData = json['driver'] ?? json['Driver'];
    DriverSimpleInfo? parsedDriver;
    if (driverData is Map<String, dynamic>) {
      parsedDriver = DriverSimpleInfo.fromJson(driverData);
    } else if (driverData is Map) {
      parsedDriver =
          DriverSimpleInfo.fromJson(Map<String, dynamic>.from(driverData));
    }

    return CarInfo(
      id: json['id'] ?? json['ID'],
      releaseDate: releaseDateVal,
      ownerId: json['ownerid'] ?? json['ownerId'] ?? json['OWNERID'],
      ownerType: json['ownertype'] ?? json['ownerType'] ?? json['OWNERTYPE'],
      chassisNo: json['chassisno'] ?? json['chassisNo'] ?? json['CHASSISNO'],
      plateNo: json['plateno'] ?? json['plateNo'] ?? json['PLATENO'],
      insuranceNo:
          json['insuranceno'] ?? json['insuranceNo'] ?? json['INSURANCENO'],
      licenceImage: parsedLicence,
      name: json['name'] ?? json['NAME'],
      brand: parsedBrand,
      model: parsedModel,
      image: parsedImage,
      totalPrice: priceVal,
      approvalStatus: approvalStatusVal,
      rejectionReason: rejectionReasonVal,
      isActive: isActiveVal,
      hasPendingUpdate: hasPendingUpdateVal,
      driver: parsedDriver,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'releasedate': releaseDate,
      'ownerid': ownerId,
      'ownertype': ownerType,
      'chassisno': chassisNo,
      'plateno': plateNo,
      'insuranceno': insuranceNo,
      'licenceimage': licenceImage != null ? base64Encode(licenceImage!) : null,
      'image': image != null ? base64Encode(image!) : null,
      'totalprice': totalPrice,
      'name': name,
      'brand': brand?.toJson(),
      'model': model?.toJson(),
      'approvalstatus': approvalStatus,
      'rejectionreason': rejectionReason,
      'isactive': isActive,
      'haspendingupdate': hasPendingUpdate,
      'driver': driver?.toJson(),
    };
  }
}

class CarBrandInfo {
  final int? carBrandId;
  final String? brandName;
  final String? brandLatinName;
  final Uint8List? image;

  const CarBrandInfo({
    this.carBrandId,
    this.brandName,
    this.brandLatinName,
    this.image,
  });

  factory CarBrandInfo.fromJson(Map<String, dynamic> json) {
    final rawImg = json['image'] ?? json['Image'] ?? json['IMAGE'];
    Uint8List? parsedImage;
    if (rawImg is String && rawImg.isNotEmpty) {
      try {
        parsedImage = base64Decode(rawImg);
      } catch (_) {}
    } else if (rawImg is Uint8List) {
      parsedImage = rawImg;
    }

    return CarBrandInfo(
      carBrandId: json['carbrandid'] ??
          json['carBrandId'] ??
          json['CARBRANDID'] ??
          json['brandId'] ??
          json['BRANDID'],
      brandName: json['brandname'] ?? json['brandName'] ?? json['BRANDNAME'],
      brandLatinName: json['brandlatinname'] ??
          json['brandLatinName'] ??
          json['BRANDLATINNAME'],
      image: parsedImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carbrandid': carBrandId,
      'brandname': brandName,
      'brandlatinname': brandLatinName,
      'image': image != null ? base64Encode(image!) : null,
    };
  }
}

class CarModelInfo {
  final int? carModelId;
  final String? modelName;
  final String? modelLatinName;
  final Uint8List? image;

  const CarModelInfo({
    this.carModelId,
    this.modelName,
    this.modelLatinName,
    this.image,
  });

  factory CarModelInfo.fromJson(Map<String, dynamic> json) {
    final rawImg = json['image'] ?? json['Image'] ?? json['IMAGE'];
    Uint8List? parsedImage;
    if (rawImg is String && rawImg.isNotEmpty) {
      try {
        parsedImage = base64Decode(rawImg);
      } catch (_) {}
    } else if (rawImg is Uint8List) {
      parsedImage = rawImg;
    }

    return CarModelInfo(
      carModelId: json['carmodelid'] ??
          json['carModelId'] ??
          json['CARMODELID'] ??
          json['modelId'] ??
          json['MODELID'],
      modelName: json['modelname'] ?? json['modelName'] ?? json['MODELNAME'],
      modelLatinName: json['modellatinname'] ??
          json['modelLatinName'] ??
          json['MODELLATINNAME'],
      image: parsedImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carmodelid': carModelId,
      'modelname': modelName,
      'modellatinname': modelLatinName,
      'image': image != null ? base64Encode(image!) : null,
    };
  }
}
