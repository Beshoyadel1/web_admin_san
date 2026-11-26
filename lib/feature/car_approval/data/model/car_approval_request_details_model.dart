import 'dart:convert';
import 'dart:typed_data';

import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_car_details_model/get_car_details_model.dart';
import 'car_approval_request_item_model.dart';

class CarApprovalRequestDetailsModel {
  final int requestId;
  final int carId;
  final int requestType; // 1 = Create, 2 = Update
  final int status; // 1 = Pending, 2 = Approved, 3 = Rejected
  final int ownerId;
  final int ownerType;
  final String ownerName;
  final String ownerPhone;
  final String? ownerEmail;
  final int carBrandId;
  final String brandName;
  final int carModelId;
  final String modelName;
  final int? releaseDate;
  final String? plateNo;
  final String? chassisNo;
  final String? insuranceNo;
  final String? carName;
  final Uint8List? licenceImage;
  final DateTime? requestDate;
  final DateTime? actionDate;
  final String? rejectionReason;
  final int? adminUserId;
  final CarInfoModel? currentActiveCar;

  const CarApprovalRequestDetailsModel({
    required this.requestId,
    required this.carId,
    required this.requestType,
    required this.status,
    required this.ownerId,
    required this.ownerType,
    required this.ownerName,
    required this.ownerPhone,
    this.ownerEmail,
    required this.carBrandId,
    required this.brandName,
    required this.carModelId,
    required this.modelName,
    this.releaseDate,
    this.plateNo,
    this.chassisNo,
    this.insuranceNo,
    this.carName,
    this.licenceImage,
    this.requestDate,
    this.actionDate,
    this.rejectionReason,
    this.adminUserId,
    this.currentActiveCar,
  });

  bool get isCreate => requestType == 1;
  bool get isUpdate => requestType == 2;
  bool get isPending => status == 1;
  bool get isApproved => status == 2;
  bool get isRejected => status == 3;

  String get displayName {
    if (carName != null && carName!.trim().isNotEmpty) {
      return carName!.trim();
    }
    final combined = '$brandName $modelName'.trim();
    if (combined.isNotEmpty) return combined;
    return plateNo ?? '#$carId';
  }

  factory CarApprovalRequestDetailsModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val, [int fallback = 0]) {
      if (val == null) return fallback;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? fallback;
    }

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString());
    }

    Uint8List? parseBytes(dynamic val) {
      if (val == null) return null;
      if (val is Uint8List) return val;
      if (val is List) return Uint8List.fromList(List<int>.from(val));
      if (val is String && val.isNotEmpty) {
        try {
          return base64Decode(val);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return CarApprovalRequestDetailsModel(
      requestId: parseInt(json['requestId'] ?? json['requestid'] ?? json['id']),
      carId: parseInt(json['carId'] ?? json['carid']),
      requestType: parseInt(json['requestType'] ?? json['requesttype'], 1),
      status: parseInt(json['status'], 1),
      ownerId: parseInt(json['ownerId'] ?? json['ownerid']),
      ownerType: parseInt(json['ownerType'] ?? json['ownertype'], 1),
      ownerName: (json['ownerName'] ?? json['ownername'] ?? '').toString(),
      ownerPhone: (json['ownerPhone'] ?? json['ownerphone'] ?? '').toString(),
      ownerEmail:
          json['ownerEmail']?.toString() ?? json['owneremail']?.toString(),
      carBrandId: parseInt(json['carBrandId'] ?? json['carbrandid']),
      brandName: (json['brandName'] ?? json['brandname'] ?? '').toString(),
      carModelId: parseInt(json['carModelId'] ?? json['carmodelid']),
      modelName: (json['modelName'] ?? json['modelname'] ?? '').toString(),
      releaseDate: json['releaseDate'] != null || json['releasedate'] != null
          ? parseInt(json['releaseDate'] ?? json['releasedate'])
          : null,
      plateNo: json['plateNo']?.toString() ?? json['plateno']?.toString(),
      chassisNo: json['chassisNo']?.toString() ?? json['chassisno']?.toString(),
      insuranceNo:
          json['insuranceNo']?.toString() ?? json['insuranceno']?.toString(),
      carName: json['carName']?.toString() ??
          json['carname']?.toString() ??
          json['name']?.toString(),
      licenceImage: parseBytes(json['licenceImage'] ?? json['licenceimage']),
      requestDate: parseDate(json['requestDate'] ?? json['requestdate']),
      actionDate: parseDate(json['actionDate'] ?? json['actiondate']),
      rejectionReason: json['rejectionReason']?.toString() ??
          json['rejectionreason']?.toString(),
      adminUserId: json['adminUserId'] != null || json['adminuserid'] != null
          ? parseInt(json['adminUserId'] ?? json['adminuserid'])
          : null,
      currentActiveCar:
          json['currentActiveCar'] != null || json['currentactivecar'] != null
              ? CarInfoModel.fromJson(
                  Map<String, dynamic>.from(
                      json['currentActiveCar'] ?? json['currentactivecar']),
                )
              : null,
    );
  }

  CarApprovalRequestItemModel toItem() {
    return CarApprovalRequestItemModel(
      requestId: requestId,
      carId: carId,
      requestType: requestType,
      status: status,
      ownerId: ownerId,
      ownerType: ownerType,
      ownerName: ownerName,
      ownerPhone: ownerPhone,
      carBrandId: carBrandId,
      brandName: brandName,
      carModelId: carModelId,
      modelName: modelName,
      releaseDate: releaseDate,
      plateNo: plateNo,
      chassisNo: chassisNo,
      insuranceNo: insuranceNo,
      carName: carName,
      hasLicenceImage: licenceImage != null && licenceImage!.isNotEmpty,
      requestDate: requestDate,
      actionDate: actionDate,
      rejectionReason: rejectionReason,
    );
  }
}
