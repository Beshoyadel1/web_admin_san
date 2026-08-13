import 'dart:convert';
import 'dart:typed_data';

class GetApprovedProvidersResponse {
  final List<ApprovedProviderModel> data;
  final int pageCount;
  final int totalCount;
  final int currentPage;

  const GetApprovedProvidersResponse({
    required this.data,
    required this.pageCount,
    required this.totalCount,
    required this.currentPage,
  });

  factory GetApprovedProvidersResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return GetApprovedProvidersResponse(
      data: json['data'] != null
          ? List<ApprovedProviderModel>.from(
        (json['data'] as List).map(
              (item) =>
              ApprovedProviderModel.fromJson(item),
        ),
      )
          : [],

      pageCount: _toInt(json['pageCount']),
      totalCount: _toInt(json['totalCount']),
      currentPage: _toInt(json['currentPage']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }
}

class ApprovedProviderModel {
  final int? providerId;

  final String? name;
  final String? latinname;
  final String? description;
  final String? latindesc;

  final int? packageid;

  final String? nationaladdress;

  final Uint8List? image;

  final ApprovalModel? approval;

  const ApprovedProviderModel({
    this.providerId,
    this.name,
    this.latinname,
    this.description,
    this.latindesc,
    this.packageid,
    this.nationaladdress,
    this.image,
    this.approval,
  });

  factory ApprovedProviderModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ApprovedProviderModel(
      providerId: _toIntNullable(
        json['providerId'],
      ),

      name: json['name']?.toString(),

      latinname:
      json['latinname']?.toString(),

      description:
      json['description']?.toString(),

      latindesc:
      json['latindesc']?.toString(),

      packageid: _toIntNullable(
        json['packageid'],
      ),

      nationaladdress:
      json['nationaladdress']?.toString(),

      image: _decodeBase64(
        json['image'],
      ),

      approval: json['approval'] != null
          ? ApprovalModel.fromJson(
        json['approval'],
      )
          : null,
    );
  }

  static int? _toIntNullable(
      dynamic value,
      ) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    );
  }

  static Uint8List? _decodeBase64(
      dynamic value,
      ) {
    if (value == null) return null;

    if (value is Uint8List) {
      return value;
    }

    final String base64String =
    value.toString();

    if (base64String.isEmpty) {
      return null;
    }

    try {
      return base64Decode(
        base64String,
      );
    } catch (_) {
      return null;
    }
  }
}

class ApprovalModel {
  final int? provid;
  final int? approvalinfoid;

  final DateTime? approvalstartdate;
  final DateTime? approvalenddate;

  final bool? isactive;

  const ApprovalModel({
    this.provid,
    this.approvalinfoid,
    this.approvalstartdate,
    this.approvalenddate,
    this.isactive,
  });

  factory ApprovalModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ApprovalModel(
      provid: _toIntNullable(
        json['provid'],
      ),

      approvalinfoid: _toIntNullable(
        json['approvalinfoid'],
      ),

      approvalstartdate:
      _parseDateTime(
        json['approvalstartdate'],
      ),

      approvalenddate:
      _parseDateTime(
        json['approvalenddate'],
      ),

      isactive: json['isactive'] is bool
          ? json['isactive']
          : json['isactive']
          ?.toString()
          .toLowerCase() ==
          'true',
    );
  }

  static int? _toIntNullable(
      dynamic value,
      ) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    );
  }

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) return null;

    return DateTime.tryParse(
      value.toString(),
    );
  }
}