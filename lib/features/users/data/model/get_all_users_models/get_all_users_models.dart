import 'dart:convert';
import 'dart:typed_data';

class GetAllUsersResponse {
  final List<GetAllUsersModels> users;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  GetAllUsersResponse({
    required this.users,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetAllUsersResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetAllUsersResponse(
      users: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => GetAllUsersModels.fromJson(e),
      )
          .toList(),
      pageCount: json['pageCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
    );
  }
}

class GetAllUsersModels {
  final int userId;
  final String? userName;
  final Uint8List? image;
  final DateTime? joinDate;
  final DateTime? lastOrderProvider;
  final bool isActive;

  GetAllUsersModels({
    required this.userId,
    this.userName,
    this.image,
    this.joinDate,
    this.lastOrderProvider,
    required this.isActive,
  });

  factory GetAllUsersModels.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetAllUsersModels(
      userId: json['userId'] ?? 0,
      userName: json['userName'],
      image: json['image'] != null
          ? base64Decode(json['image'])
          : null,
      joinDate: json['joinDate'] != null
          ? DateTime.tryParse(
        json['joinDate'],
      )
          : null,
      lastOrderProvider:
      json['lastOrderProvider'] != null
          ? DateTime.tryParse(
        json['lastOrderProvider']['date'],
      )
          : null,
      isActive: json['isActive'] ?? false,
    );
  }
}