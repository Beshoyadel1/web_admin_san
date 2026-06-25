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


class GetAllCompanies {
  final int? companyId;
  final String? name,latinName;
  final Uint8List? image;
  final DateTime? joinDate;
  final DateTime? lastOrderProvider;
  final bool? isActive;

  GetAllCompanies({
    required this.companyId,
    this.name,
    this.latinName,
    this.image,
    this.joinDate,
    this.lastOrderProvider,
     this.isActive,
  });

  factory GetAllCompanies.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetAllCompanies(
      companyId: json['companyId'] ?? 0,
      name: json['name'],
      latinName: json['latinName'],
      image: json['image'] != null
          ? base64Decode(json['image'])
          : null,
      joinDate: json['joinDate'] != null
          ? DateTime.tryParse(
        json['joinDate'],
      )
          : null,
      lastOrderProvider: json['lastOrderProvider'] != null
          ? DateTime.tryParse(json['lastOrderProvider'].toString())
          : null,

      isActive: json['isActive'] ?? true,
    );
  }
}