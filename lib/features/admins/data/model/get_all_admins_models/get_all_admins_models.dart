import 'dart:convert';
import 'dart:typed_data';


class GetAllAdminsResponse {
  final List<AdminModel> admins;
  final int? pageCount;
  final int? totalCount;
  final int? currentPage;

  const GetAllAdminsResponse({
    required this.admins,
    this.pageCount,
    this.totalCount,
    this.currentPage,
  });

  factory GetAllAdminsResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final adminsData = json['data'];

    return GetAllAdminsResponse(
      admins: adminsData is List
          ? adminsData
          .whereType<Map<String, dynamic>>()
          .map(
        AdminModel.fromJson,
      )
          .toList()
          : [],

      pageCount: _toInt(
        json['pageCount'],
      ),

      totalCount: _toInt(
        json['totalCount'],
      ),

      currentPage: _toInt(
        json['currentPage'],
      ),
    );
  }

  static int? _toInt(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }
}


// =======================================================
// ADMIN MODEL
// =======================================================

class AdminModel {
  final int? adminId;
  final String? userName;
  final String? phone;
  final String? email;
  final String? jobName;
  final String? jobLatinName;

  final Uint8List? image;

  final bool? isActive;
  final DateTime? joinDate;

  final AdminPermissionsModel? permissions;

  const AdminModel({
    this.adminId,
    this.userName,
    this.phone,
    this.email,
    this.jobName,
    this.jobLatinName,
    this.image,
    this.isActive,
    this.joinDate,
    this.permissions,
  });

  factory AdminModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdminModel(
      adminId: _toInt(
        json['adminId'],
      ),

      userName: _toString(
        json['userName'],
      ),

      phone: _toString(
        json['phone'],
      ),

      email: _toString(
        json['email'],
      ),

      jobName: _toString(
        json['jobName'],
      ),

      jobLatinName: _toString(
        json['jobLatinName'],
      ),

      image: _base64ToUint8List(
        json['image'],
      ),

      isActive: _toBool(
        json['isActive'],
      ),

      joinDate: _toDateTime(
        json['joinDate'],
      ),

      permissions:
      json['permissions'] is Map<String, dynamic>
          ? AdminPermissionsModel.fromJson(
        json['permissions'],
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'userName': userName,
      'phone': phone,
      'email': email,
      'jobName': jobName,
      'jobLatinName': jobLatinName,

      'image': image != null
          ? base64Encode(image!)
          : null,

      'isActive': isActive,

      'joinDate':
      joinDate?.toIso8601String(),

      'permissions':
      permissions?.toJson(),
    };
  }

  // =====================================================
  // HELPERS
  // =====================================================

  static int? _toInt(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  static String? _toString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

  static bool? _toBool(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final lowerValue =
      value.toLowerCase();

      if (lowerValue == 'true' ||
          lowerValue == '1') {
        return true;
      }

      if (lowerValue == 'false' ||
          lowerValue == '0') {
        return false;
      }
    }

    return null;
  }

  static DateTime? _toDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  static Uint8List? _base64ToUint8List(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is Uint8List) {
      return value;
    }

    if (value is! String ||
        value.isEmpty) {
      return null;
    }

    try {
      return base64Decode(
        value,
      );
    } catch (_) {
      return null;
    }
  }
}


// =======================================================
// ADMIN PERMISSIONS
// =======================================================

class AdminPermissionsModel {
  final int? adminId;

  final bool? statistic;
  final bool? orders;
  final bool? providers;
  final bool? companies;
  final bool? users;
  final bool? finances;
  final bool? packages;
  final bool? approvals;
  final bool? ranks;
  final bool? support;
  final bool? admins;
  final bool? banners;
  final bool? coupons;
  final bool? harage;
  final bool? insurance;

  const AdminPermissionsModel({
    this.adminId,
    this.statistic,
    this.orders,
    this.providers,
    this.companies,
    this.users,
    this.finances,
    this.packages,
    this.approvals,
    this.ranks,
    this.support,
    this.admins,
    this.banners,
    this.coupons,
    this.harage,
    this.insurance,
  });

  factory AdminPermissionsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdminPermissionsModel(
      adminId: _toInt(
        json['adminid'] ??
            json['adminId'],
      ),

      statistic: _toBool(
        json['statistic'],
      ),

      orders: _toBool(
        json['orders'],
      ),

      providers: _toBool(
        json['providers'],
      ),

      companies: _toBool(
        json['companies'],
      ),

      users: _toBool(
        json['users'],
      ),

      finances: _toBool(
        json['finances'],
      ),

      packages: _toBool(
        json['packages'],
      ),

      approvals: _toBool(
        json['approvals'],
      ),

      ranks: _toBool(
        json['ranks'],
      ),

      support: _toBool(
        json['support'],
      ),

      admins: _toBool(
        json['admins'],
      ),

      banners: _toBool(
        json['banners'],
      ),

      coupons: _toBool(
        json['coupons'],
      ),

      harage: _toBool(
        json['harage'],
      ),

      insurance: _toBool(
        json['insurance'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminid': adminId,
      'statistic': statistic,
      'orders': orders,
      'providers': providers,
      'companies': companies,
      'users': users,
      'finances': finances,
      'packages': packages,
      'approvals': approvals,
      'ranks': ranks,
      'support': support,
      'admins': admins,
      'banners': banners,
      'coupons': coupons,
      'harage': harage,
      'insurance': insurance,
    };
  }

  static int? _toInt(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  static bool? _toBool(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final lowerValue =
      value.toLowerCase();

      if (lowerValue == 'true' ||
          lowerValue == '1') {
        return true;
      }

      if (lowerValue == 'false' ||
          lowerValue == '0') {
        return false;
      }
    }

    return null;
  }
}