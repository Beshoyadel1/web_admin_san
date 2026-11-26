import 'dart:convert';
import 'dart:typed_data';

class BrandModel {
  final int brandId;
  final String brandName;
  final String brandLatinName;
  final String? image;

  BrandModel({
    required this.brandId,
    required this.brandName,
    required this.brandLatinName,
    this.image,
  });

  Uint8List? get imageBytes {
    if (image == null || image!.trim().isEmpty) return null;
    try {
      final clean = image!.contains(',') ? image!.split(',').last : image!;
      return base64Decode(clean.trim());
    } catch (_) {
      return null;
    }
  }

  String getLocalizedName(String langCode) =>
      langCode == 'ar' ? brandName : brandLatinName;
  String getLocalizedSubName(String langCode) =>
      langCode == 'ar' ? brandLatinName : brandName;

  BrandModel copyWith({
    int? brandId,
    String? brandName,
    String? brandLatinName,
    String? image,
  }) {
    return BrandModel(
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      brandLatinName: brandLatinName ?? this.brandLatinName,
      image: image ?? this.image,
    );
  }

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandId: json['brandid'] ?? json['brandId'] ?? 0,
      brandName: json['brandname'] ?? json['brandName'] ?? '',
      brandLatinName: json['brandlatinname'] ?? json['brandLatinName'] ?? '',
      image: json['image'] ?? json['brandImage'],
    );
  }

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      "brandname": brandName,
      "brandlatinname": brandLatinName,
      "image": image ?? "",
    };

    if (isUpdate) {
      data["brandid"] = brandId;
    }
    return data;
  }
}
