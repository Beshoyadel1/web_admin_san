import 'dart:convert';
import 'dart:typed_data';

class GetHarageProvidersModels {
  final List<GetAllProviderHarag> providers;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  GetHarageProvidersModels({
    required this.providers,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetHarageProvidersModels.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetHarageProvidersModels(
      providers: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => GetAllProviderHarag.fromJson(e),
      )
          .toList(),
      pageCount: json['pageCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
    );
  }
}


class GetAllProviderHarag {
  final int? providerId,totalCars;
  final String? name,latinName;
  final Uint8List? image;
  final DateTime? joinDate;
  final DateTime? lastAddedDate;
  final bool isActive;

  GetAllProviderHarag({
    required this.providerId,
    this.name,
    this.latinName,
    this.image,
    this.joinDate,
    this.lastAddedDate,
    required this.isActive,
    this.totalCars,
  });

  factory GetAllProviderHarag.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetAllProviderHarag(
      providerId: json['providerId'] ?? 0,
      totalCars: json['totalCars'],
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
      lastAddedDate: json['lastAddedDate'] != null
          ? DateTime.tryParse(json['lastAddedDate'].toString())
          : null,

      isActive: json['isActive'] ?? false,
    );
  }
}