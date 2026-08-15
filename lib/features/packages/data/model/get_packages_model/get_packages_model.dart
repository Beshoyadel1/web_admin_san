import 'package:flutter/cupertino.dart';

class PackageModel {
  final int? packageid;
  final String? packagename;
  final String? packagelatinname;
  final double? annualprice;
  final double? monthprice;
  final String? packagedisc;
  final String? packagelatindisc;

  const PackageModel({
    this.packageid,
    this.packagename,
    this.packagelatinname,
    this.annualprice,
    this.monthprice,
    this.packagedisc,
    this.packagelatindisc,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageid: _toInt(json['packageid']),
      packagename: json['packagename']?.toString(),
      packagelatinname: json['packagelatinname']?.toString(),
      annualprice: _toDouble(json['annualprice']),
      monthprice: _toDouble(json['monthprice']),
      packagedisc: json['packagedisc']?.toString(),
      packagelatindisc: json['packagelatindisc']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageid': packageid,
      'packagename': packagename,
      'packagelatinname': packagelatinname,
      'annualprice': annualprice,
      'monthprice': monthprice,
      'packagedisc': packagedisc,
      'packagelatindisc': packagelatindisc,
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is double) return value;

    if (value is int) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0;
  }

  bool _isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  String? getName(BuildContext context) {
    return _isEnglish(context)
        ? packagelatinname
        : packagename;
  }

  String? getDescription(BuildContext context) {
    return _isEnglish(context)
        ? packagelatinname
        : packagedisc;
  }
}