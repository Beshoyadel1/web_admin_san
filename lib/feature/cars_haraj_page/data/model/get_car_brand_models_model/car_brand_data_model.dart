import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class CarBrandDataModel {
  final int? id;
  final String? name;
  final String? latinName;
  final Uint8List? image;

  CarBrandDataModel({
    this.id,
    this.name,
    this.latinName,
    this.image,
  });

  factory CarBrandDataModel.fromJson(Map<String, dynamic> json) {
    return CarBrandDataModel(
      id: json['brandid'] ?? 0,
      name: json['brandname']?.toString() ?? "",
      latinName: json['brandlatinname']?.toString() ?? "",
      image: json['image'] != null ? base64Decode(json["image"]) : null,
    );
  }

  String getName(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return isArabic ? (name ?? "") : (latinName ?? "");
  }
}
