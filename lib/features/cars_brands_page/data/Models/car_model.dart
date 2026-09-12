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

  factory CarsBrandModel.fromJson(Map<String, dynamic> json) {
    return CarsBrandModel(
      modelId: json['modelid'] ?? 0,
      modelName: json['modelname'] ?? '',
      carBrandId: json['carbrandid'] ?? 0,
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