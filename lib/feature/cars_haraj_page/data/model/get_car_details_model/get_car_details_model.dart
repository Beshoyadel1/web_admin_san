import 'dart:typed_data';

class GetCarDetailsModel {
  final CarInfoModel? carInfo;
  final SummaryModel? summary;
  final FuelConsumptionModel? fuelConsumption;
  final List<ServiceStatsModel> serviceStats;
  final List<RecentInvoiceModel> recentInvoices;
  final List<DriverModel> drivers;

  GetCarDetailsModel({
    this.carInfo,
    this.summary,
    this.fuelConsumption,
    this.serviceStats = const [],
    this.recentInvoices = const [],
    this.drivers = const [],
  });

  factory GetCarDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetCarDetailsModel(
      carInfo: json['carInfo'] != null
          ? CarInfoModel.fromJson(json['carInfo'])
          : null,
      summary: json['summary'] != null
          ? SummaryModel.fromJson(json['summary'])
          : null,
      fuelConsumption: json['fuelConsumption'] != null
          ? FuelConsumptionModel.fromJson(json['fuelConsumption'])
          : null,
      serviceStats: (json['serviceStats'] as List?)
              ?.map(
                (e) => ServiceStatsModel.fromJson(e),
              )
              .toList() ??
          [],
      recentInvoices: (json['recentInvoices'] as List?)
              ?.map(
                (e) => RecentInvoiceModel.fromJson(e),
              )
              .toList() ??
          [],
      drivers: (json['drivers'] as List?)
              ?.map(
                (e) => DriverModel.fromJson(e),
              )
              .toList() ??
          [],
    );
  }
}

class CarInfoModel {
  final int? id;
  final int? releaseDate;
  final int? ownerId;
  final int? ownerType;
  final String? chassisNo;
  final String? plateNo;
  final String? insuranceNo;
  final Uint8List? licenceImage;
  final String? name;
  final CarBrandModel? brand;
  final CarModelBrandDataModel? model;
  final int? approvalStatus;
  final String? rejectionReason;
  final bool? isActive;
  final bool? hasPendingUpdate;

  CarInfoModel({
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
    this.approvalStatus = 2,
    this.rejectionReason,
    this.isActive = true,
    this.hasPendingUpdate = false,
  });

  bool get isApproved => (approvalStatus ?? 2) == 2 && (isActive ?? true);
  bool get isPending => (approvalStatus ?? 2) == 1;
  bool get isRejected => (approvalStatus ?? 2) == 3;

  factory CarInfoModel.fromJson(Map<String, dynamic> json) {
    final rawApprovalStatus = json['approvalstatus'] ??
        json['approvalStatus'] ??
        json['APPROVALSTATUS'];
    final approvalStatusVal = rawApprovalStatus is int
        ? rawApprovalStatus
        : int.tryParse(rawApprovalStatus?.toString() ?? '') ?? 2;

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

    return CarInfoModel(
      id: json['id'] ?? json['ID'],
      releaseDate:
          json['releasedate'] ?? json['releaseDate'] ?? json['RELEASEDATE'],
      ownerId: json['ownerid'] ?? json['ownerId'] ?? json['OWNERID'],
      ownerType: json['ownertype'] ?? json['ownerType'] ?? json['OWNERTYPE'],
      chassisNo: json['chassisno'] ?? json['chassisNo'] ?? json['CHASSISNO'],
      plateNo: json['plateno'] ?? json['plateNo'] ?? json['PLATENO'],
      insuranceNo:
          json['insuranceno'] ?? json['insuranceNo'] ?? json['INSURANCENO'],
      licenceImage: json['licenceimage'] is List
          ? Uint8List.fromList(
              List<int>.from(json['licenceimage']),
            )
          : null,
      name: json['name'] ?? json['NAME'],
      brand:
          json['brand'] != null ? CarBrandModel.fromJson(json['brand']) : null,
      model: json['model'] != null
          ? CarModelBrandDataModel.fromJson(json['model'])
          : null,
      approvalStatus: approvalStatusVal,
      rejectionReason: (json['rejectionreason'] ??
              json['rejectionReason'] ??
              json['REJECTIONREASON'])
          ?.toString(),
      isActive: isActiveVal,
      hasPendingUpdate: hasPendingUpdateVal,
    );
  }
}

class CarBrandModel {
  final int? carBrandId;
  final String? brandName;
  final String? brandLatinName;
  final Uint8List? image;

  CarBrandModel({
    this.carBrandId,
    this.brandName,
    this.brandLatinName,
    this.image,
  });

  factory CarBrandModel.fromJson(Map<String, dynamic> json) {
    return CarBrandModel(
      carBrandId: json['carbrandid'],
      brandName: json['brandname'],
      brandLatinName: json['brandlatinname'],
      image: json['image'] is List
          ? Uint8List.fromList(
              List<int>.from(json['image']),
            )
          : null,
    );
  }
}

class CarModelBrandDataModel {
  final int? carModelId;
  final String? modelName;
  final Uint8List? image;

  CarModelBrandDataModel({
    this.carModelId,
    this.modelName,
    this.image,
  });

  factory CarModelBrandDataModel.fromJson(Map<String, dynamic> json) {
    return CarModelBrandDataModel(
      carModelId: json['carmodelid'],
      modelName: json['modelname'],
      image: json['image'] is List
          ? Uint8List.fromList(
              List<int>.from(json['image']),
            )
          : null,
    );
  }
}

class SummaryModel {
  final double? totalInvoices;
  final double? totalPetrol;
  final int? maintenanceCount;
  final int? refuelCount;

  SummaryModel({
    this.totalInvoices,
    this.totalPetrol,
    this.maintenanceCount,
    this.refuelCount,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      totalInvoices: (json['totalInvoices'] as num?)?.toDouble(),
      totalPetrol: (json['totalPetrol'] as num?)?.toDouble(),
      maintenanceCount: json['maintenanceCount'],
      refuelCount: json['refuelCount'],
    );
  }
}

class FuelConsumptionModel {
  final double? consumptionPercentage;
  final double? totalConsumption;
  final double? expectedSpend;

  FuelConsumptionModel({
    this.consumptionPercentage,
    this.totalConsumption,
    this.expectedSpend,
  });

  factory FuelConsumptionModel.fromJson(Map<String, dynamic> json) {
    return FuelConsumptionModel(
      consumptionPercentage:
          (json['consumptionPercentage'] as num?)?.toDouble(),
      totalConsumption: (json['totalConsumption'] as num?)?.toDouble(),
      expectedSpend: (json['expectedSpend'] as num?)?.toDouble(),
    );
  }
}

class ServiceStatsModel {
  final String? serviceName;
  final String? serviceLatinName;
  final double? value;
  final double? percentage;

  ServiceStatsModel({
    this.serviceName,
    this.serviceLatinName,
    this.value,
    this.percentage,
  });

  factory ServiceStatsModel.fromJson(Map<String, dynamic> json) {
    return ServiceStatsModel(
      serviceName: json['serviceName'],
      serviceLatinName: json['serviceLatinName'],
      value: (json['value'] as num?)?.toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble(),
    );
  }
}

class RecentInvoiceModel {
  final int? id;
  final DateTime? date;
  final String? categoryName;
  final double? amount;

  RecentInvoiceModel({
    this.id,
    this.date,
    this.categoryName,
    this.amount,
  });

  factory RecentInvoiceModel.fromJson(Map<String, dynamic> json) {
    return RecentInvoiceModel(
      id: json['id'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      categoryName: json['categoryName'],
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }
}

class DriverModel {
  DriverModel();

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel();
  }
}
