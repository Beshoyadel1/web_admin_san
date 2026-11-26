import 'dart:convert';
import 'dart:typed_data';

class GetAllCompaniesModel {
  final List<GetAllCompanies> company;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  GetAllCompaniesModel({
    required this.company,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetAllCompaniesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetAllCompaniesModel(
      company: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => GetAllCompanies.fromJson(e),
          )
          .toList(),
      pageCount: json['pageCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
    );
  }
}

class LastOrderProviderModel {
  final int? providerId;
  final String? name;
  final String? latinName;
  final Uint8List? image;
  final DateTime? date;

  LastOrderProviderModel({
    this.providerId,
    this.name,
    this.latinName,
    this.image,
    this.date,
  });

  factory LastOrderProviderModel.fromJson(Map<String, dynamic> json) {
    return LastOrderProviderModel(
      providerId: json['providerId'],
      name: json['name'],
      latinName: json['latinName'],
      image: json['image'] != null ? base64Decode(json['image']) : null,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,
    );
  }
}

class GetAllCompanies {
  final int? companyId;
  final String? name, latinName;
  final Uint8List? image;
  final DateTime? joinDate;
  final DateTime? lastOrderProvider;
  final LastOrderProviderModel? lastOrderProviderModel;
  final bool? isActive;

  GetAllCompanies({
    required this.companyId,
    this.name,
    this.latinName,
    this.image,
    this.joinDate,
    this.lastOrderProvider,
    this.lastOrderProviderModel,
    this.isActive,
  });

  factory GetAllCompanies.fromJson(
    Map<String, dynamic> json,
  ) {
    LastOrderProviderModel? providerModel;
    DateTime? orderDate;

    if (json['lastOrderProvider'] != null) {
      if (json['lastOrderProvider'] is Map<String, dynamic>) {
        providerModel = LastOrderProviderModel.fromJson(
          json['lastOrderProvider'] as Map<String, dynamic>,
        );
        orderDate = providerModel.date;
      } else if (json['lastOrderProvider'] is Map) {
        providerModel = LastOrderProviderModel.fromJson(
          Map<String, dynamic>.from(json['lastOrderProvider'] as Map),
        );
        orderDate = providerModel.date;
      } else {
        orderDate = DateTime.tryParse(json['lastOrderProvider'].toString());
      }
    }

    return GetAllCompanies(
      companyId: json['companyId'] ?? 0,
      name: json['name'],
      latinName: json['latinName'],
      image: json['image'] != null ? base64Decode(json['image']) : null,
      joinDate: json['joinDate'] != null
          ? DateTime.tryParse(
              json['joinDate'],
            )
          : null,
      lastOrderProvider: orderDate,
      lastOrderProviderModel: providerModel,
      isActive: json['isActive'] ?? true,
    );
  }
}
