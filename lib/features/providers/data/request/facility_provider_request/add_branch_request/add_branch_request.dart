import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language_cubit/language_cubit.dart';

class AddBranchRequest {
  final int? branchId;
  final String? branchName;
  final String? branchLatinName;
  final String? address;
  final String? addressText;
  final String? addressLatinText;
  final String? nationalAddress;
  final double? lat, long;
  final bool? isActive;

  AddBranchRequest({
    this.branchId,
    this.branchName,
    this.branchLatinName,
    this.address,
    this.addressText,
    this.addressLatinText,
    this.nationalAddress,
    this.lat,
    this.long,
    this.isActive = true,
  });

  Map<String, dynamic> toJson(int providerId) {
    return {
      if (branchId != null) "branchid": branchId,
      "branchname": branchName,
      "branchlatinname": branchLatinName,
      "address": address,
      "addresstext": addressText,
      "addresslatintext": addressLatinText,
      "nationaladdress": nationalAddress,
      "lat": lat,
      "long": long,
      "provid": providerId,
      "isactive": isActive,
    };
  }

  String? getBranchName(BuildContext context) {
    final isArabic = LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? branchName : branchLatinName;
  }

  String? getAddressText(BuildContext context) {
    final isArabic = LanguageCubit.get(context).isAllAppLanguageArabic;

    return isArabic ? addressText : addressLatinText;
  }
}
