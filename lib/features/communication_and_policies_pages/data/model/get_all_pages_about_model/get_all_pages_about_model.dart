class AboutPageModel {
  final int id;
  final String? titleText;
  final String? titleTextEn;
  final String? contentText;
  final String? contentTextEn;
  final DateTime? lastModified;

  AboutPageModel({
    required this.id,
    this.titleText,
    this.titleTextEn,
    this.contentText,
    this.contentTextEn,
    this.lastModified,
  });

  factory AboutPageModel.fromJson(Map<String, dynamic> json) {
    return AboutPageModel(
      id: json["id"] ?? 0,
      titleText: json["titletext"],
      titleTextEn: json["titletexten"],
      contentText: json["contenttext"],
      contentTextEn: json["contenttexten"],
      lastModified: json["lastmodified"] != null
          ? DateTime.tryParse(json["lastmodified"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "titletext": titleText,
      "titletexten": titleTextEn,
      "contenttext": contentText,
      "contenttexten": contentTextEn,
    };
  }

  String getTitle(bool isArabic) {
    return isArabic
        ? (titleText ?? "")
        : (titleTextEn ?? titleText ?? "");
  }

  String getContent(bool isArabic) {
    return isArabic
        ? (contentText ?? "")
        : (contentTextEn ?? contentText ?? "");
  }
}