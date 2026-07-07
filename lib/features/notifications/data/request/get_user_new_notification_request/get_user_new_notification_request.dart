class GetUserNewNotificationResponse {
  final int? id;
  final String? title;
  final String? latinTitle;
  final String? description;
  final String? latinDesc;
  final int? toUserId;
  final int? toUserType;
  final int? fromUserId;
  final int? fromUserType;
  final bool? isViewed;
  final DateTime? date;

  GetUserNewNotificationResponse({
    this.id,
    this.title,
    this.latinTitle,
    this.description,
    this.latinDesc,
    this.toUserId,
    this.toUserType,
    this.fromUserId,
    this.fromUserType,
    this.isViewed,
    this.date,
  });

  factory GetUserNewNotificationResponse.fromJson(
      Map<String, dynamic> json) {
    return GetUserNewNotificationResponse(
      id: json["id"],
      title: json["title"],
      latinTitle: json["latintitle"],
      description: json["description"],
      latinDesc: json["latindesc"],
      toUserId: json["touserid"],
      toUserType: json["tousertype"],
      fromUserId: json["fromuserid"],
      fromUserType: json["fromusertype"],
      isViewed: json["isviewed"],
      date:
      json["date"] == null ? null : DateTime.parse(json["date"]),
    );
  }
}