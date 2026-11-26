class CarApprovalRequestItemModel {
  final int requestId;
  final int carId;
  final int requestType; // 1 = Create, 2 = Update
  final int status; // 1 = Pending, 2 = Approved, 3 = Rejected
  final int ownerId;
  final int ownerType;
  final String ownerName;
  final String ownerPhone;
  final int carBrandId;
  final String brandName;
  final int carModelId;
  final String modelName;
  final int? releaseDate;
  final String? plateNo;
  final String? chassisNo;
  final String? insuranceNo;
  final String? carName;
  final bool hasLicenceImage;
  final DateTime? requestDate;
  final DateTime? actionDate;
  final String? rejectionReason;

  const CarApprovalRequestItemModel({
    required this.requestId,
    required this.carId,
    required this.requestType,
    required this.status,
    required this.ownerId,
    required this.ownerType,
    required this.ownerName,
    required this.ownerPhone,
    required this.carBrandId,
    required this.brandName,
    required this.carModelId,
    required this.modelName,
    this.releaseDate,
    this.plateNo,
    this.chassisNo,
    this.insuranceNo,
    this.carName,
    this.hasLicenceImage = false,
    this.requestDate,
    this.actionDate,
    this.rejectionReason,
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

  factory CarApprovalRequestItemModel.fromJson(Map<String, dynamic> json) {
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

    return CarApprovalRequestItemModel(
      requestId: parseInt(json['requestId'] ?? json['requestid'] ?? json['id']),
      carId: parseInt(json['carId'] ?? json['carid']),
      requestType: parseInt(json['requestType'] ?? json['requesttype'], 1),
      status: parseInt(json['status'], 1),
      ownerId: parseInt(json['ownerId'] ?? json['ownerid']),
      ownerType: parseInt(json['ownerType'] ?? json['ownertype'], 1),
      ownerName: (json['ownerName'] ?? json['ownername'] ?? '').toString(),
      ownerPhone: (json['ownerPhone'] ?? json['ownerphone'] ?? '').toString(),
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
      hasLicenceImage: json['hasLicenceImage'] == true ||
          json['haslicenceimage'] == true ||
          json['licenceImage'] != null ||
          json['licenceimage'] != null,
      requestDate: parseDate(json['requestDate'] ?? json['requestdate']),
      actionDate: parseDate(json['actionDate'] ?? json['actiondate']),
      rejectionReason: json['rejectionReason']?.toString() ??
          json['rejectionreason']?.toString(),
    );
  }
}
