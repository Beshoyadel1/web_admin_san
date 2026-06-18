import 'dart:convert';
import 'dart:typed_data';

import 'dart:convert';
import 'dart:typed_data';

class BannerModel {
  final int? imageId;
  final Uint8List? image;
  final DateTime? startDate;
  final DateTime? endDate;

  BannerModel({
    this.imageId,
    this.image,
    this.startDate,
    this.endDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      imageId: json['imageid'],
      image: json['image'] != null
          ? base64Decode(json['image'])
          : null,
      startDate: json['startdate'] != null
          ? DateTime.parse(json['startdate'])
          : null,
      endDate: json['enddate'] != null
          ? DateTime.parse(json['enddate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "imageid": imageId ?? 0,
      "image": image != null ? base64Encode(image!) : null,
      "startdate": startDate?.toUtc().toIso8601String(),
      "enddate": endDate?.toUtc().toIso8601String(),
    };
  }
}