import 'dart:convert';
import 'dart:typed_data';

class GetAllProvidersResponse {
  final List<GetAllProvidersModels> providers;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  GetAllProvidersResponse({
    required this.providers,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetAllProvidersResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetAllProvidersResponse(
      providers: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => GetAllProvidersModels.fromJson(
          e,
        ),
      )
          .toList(),

      pageCount: json['pageCount'] ?? 0,

      totalCount: json['totalCount'] ?? 0,

      currentPage: json['currentPage'] ?? 1,
    );
  }
}
class GetAllProvidersModels {
  final int providerId;
  final String? name;
  final String? latinName;
  final Uint8List? image;
  final int totalOrders;
  final DateTime? lastOrderDate;
  final bool isActive;
  final DateTime? joinDate;

  GetAllProvidersModels({
    required this.providerId,
    this.name,
    this.latinName,
    this.image,
    required this.totalOrders,
    this.lastOrderDate,
    required this.isActive,
    this.joinDate,
  });

  factory GetAllProvidersModels.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetAllProvidersModels(
      providerId: json['providerId'] ?? 0,
      name: json['name'],
      latinName: json['latinName'],
      image: json['image'] != null
          ? base64Decode(json['image'])
          : null,
      totalOrders: json['totalOrders'] ?? 0,
      lastOrderDate: json['lastOrderDate'] != null
          ? DateTime.tryParse(
        json['lastOrderDate'],
      )
          : null,
      isActive: json['isActive'] ?? false,
      joinDate: json['joinDate'] != null
          ? DateTime.tryParse(
        json['joinDate'],
      )
          : null,
    );
  }
}