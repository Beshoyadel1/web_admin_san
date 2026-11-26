import 'dart:convert';
import 'dart:typed_data';

class CarsBrandModel {
  final int modelId;
  final String modelName;
  final int carBrandId;
  final String? image;

  CarsBrandModel({
    required this.modelId,
    required this.modelName,
    required this.carBrandId,
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

  CarsBrandModel copyWith({
    int? modelId,
    String? modelName,
    int? carBrandId,
    String? image,
  }) {
    return CarsBrandModel(
      modelId: modelId ?? this.modelId,
      modelName: modelName ?? this.modelName,
      carBrandId: carBrandId ?? this.carBrandId,
      image: image ?? this.image,
    );
  }

  factory CarsBrandModel.fromJson(Map<String, dynamic> json) {
    return CarsBrandModel(
      modelId: json['modelid'] ?? json['modelId'] ?? 0,
      modelName: json['modelname'] ?? json['modelName'] ?? '',
      carBrandId: json['carbrandid'] ?? json['carBrandId'] ?? 0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson({bool isUpdate = false}) {
    final Map<String, dynamic> data = {
      "modelname": modelName,
      "carbrandid": carBrandId,
      "image": image ?? "",
    };

    if (isUpdate) {
      data["modelid"] = modelId;
    }
    return data;
  }
}
