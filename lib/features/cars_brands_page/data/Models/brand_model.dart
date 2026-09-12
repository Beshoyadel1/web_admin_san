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

  String getLocalizedName(String langCode) => langCode == 'ar' ? brandName : brandLatinName;
  String getLocalizedSubName(String langCode) => langCode == 'ar' ? brandLatinName : brandName;

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandId: json['brandid'] ?? 0,
      brandName: json['brandname'] ?? '',
      brandLatinName: json['brandlatinname'] ?? '',
      image: json['image'],
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