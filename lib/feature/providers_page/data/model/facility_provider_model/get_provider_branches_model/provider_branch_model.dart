import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class ProviderBranchModel {
  final int? branchId;
  final String? branchName;
  final String? branchLatinName;
  final String? address;
  final String? addressText;
  final String? addressLatinText;
  final String? nationalAddress;
  final double? lat;
  final double? long;
  final int? providerId;
  final bool? isActive;

  ProviderBranchModel({
    this.branchId,
    this.branchName,
    this.branchLatinName,
    this.address,
    this.addressText,
    this.addressLatinText,
    this.nationalAddress,
    this.lat,
    this.long,
    this.providerId,
    this.isActive = true,
  });

  factory ProviderBranchModel.fromJson(Map<String, dynamic> json) {
    return ProviderBranchModel(
      branchId: json['branchid'],
      branchName: json['branchname'] ?? '',
      branchLatinName: json['branchlatinname'] ?? '',
      address: json['address'] ?? '',
      addressText: json['addresstext'] ?? '',
      addressLatinText: json['addresslatintext'] ?? '',
      nationalAddress: json['nationaladdress'] ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      providerId: json['provid'],
      isActive: json['isactive'] ?? false,
    );
  }

  static List<ProviderBranchModel> fromList(List list) {
    return list.map((e) => ProviderBranchModel.fromJson(e)).toList();
  }

  String getBranchName(BuildContext context) {
    try {
      final isArabic = context.locale.languageCode == 'ar';
      return isArabic ? (branchName ?? "") : (branchLatinName ?? "");
    } catch (_) {
      return (branchName != null && branchName!.isNotEmpty)
          ? branchName!
          : (branchLatinName ?? "");
    }
  }

  String getAddressText(BuildContext context) {
    try {
      final isArabic = context.locale.languageCode == 'ar';
      return isArabic ? (addressText ?? "") : (addressLatinText ?? "");
    } catch (_) {
      return (addressText != null && addressText!.isNotEmpty)
          ? addressText!
          : (addressLatinText ?? "");
    }
  }
}
