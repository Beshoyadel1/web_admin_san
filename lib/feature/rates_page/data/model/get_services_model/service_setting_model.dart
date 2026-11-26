import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class ServiceSettingModel {
  final int? id;
  final int? parentId;
  final String? name;
  final String? latinName;

  final Uint8List? image;

  ServiceSettingModel({
    this.id,
    this.name,
    this.latinName,
    this.image,
    this.parentId,
  });

  factory ServiceSettingModel.fromJson(Map<String, dynamic> json) {
    return ServiceSettingModel(
      id: json['id'] ?? 0,
      parentId: json['parentid'] ?? 0,
      name: json['name']?.toString() ?? "",
      latinName: json['latinname']?.toString() ?? "",
      image: json['image'] != null ? base64Decode(json['image']) : null,
    );
  }

  String getName(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return isArabic ? (name ?? "") : (latinName ?? "");
  }
}
