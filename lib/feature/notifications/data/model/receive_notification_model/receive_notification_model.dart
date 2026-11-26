import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class ReceiveNotificationModel {
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

  ReceiveNotificationModel({
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

  factory ReceiveNotificationModel.fromJson(Map<String, dynamic> rawJson) {
    final json = <String, dynamic>{};
    rawJson.forEach((k, v) => json[k.toString().toLowerCase()] = v);

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString());
    }

    bool? parseBool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      final s = v.toString().toLowerCase().trim();
      return s == 'true' || s == '1';
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v.toLocal();
      final s = v.toString().trim();
      return DateTime.tryParse(s)?.toLocal();
    }

    return ReceiveNotificationModel(
      id: parseInt(json["id"]),
      title: (json["title"] ?? json["ar_title"])?.toString() ?? "",
      latinTitle: (json["latintitle"] ?? json["en_title"])?.toString() ?? "",
      description: (json["description"] ??
                  json["body"] ??
                  json["ar_body"] ??
                  json["message"])
              ?.toString() ??
          "",
      latinDesc: (json["latindesc"] ?? json["en_body"])?.toString() ?? "",
      toUserId: parseInt(json["touserid"] ?? json["touser"] ?? json["userid"]),
      toUserType: parseInt(json["tousertype"] ?? json["usertype"]),
      fromUserId: parseInt(json["fromuserid"] ?? json["fromuser"]),
      fromUserType: parseInt(json["fromusertype"]),
      isViewed: parseBool(json["isviewed"]) ?? false,
      date: parseDate(json["date"]) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "TITLE": title,
      "LATINTITLE": latinTitle,
      "DESCRIPTION": description,
      "LATINDESC": latinDesc,
      "TOUSERID": toUserId,
      "TOUSERTYPE": toUserType,
      "FROMUSERID": fromUserId,
      "FROMUSERTYPE": fromUserType,
      "ISVIEWED": isViewed,
      "DATE": date?.toIso8601String(),
    };
  }

  bool _isEnglish([BuildContext? context]) {
    if (context == null) return false;
    return Localizations.localeOf(context).languageCode == 'en';
  }

  String getTitle([BuildContext? context]) {
    return _isEnglish(context)
        ? (latinTitle?.isNotEmpty == true ? latinTitle! : (title ?? ""))
        : (title?.isNotEmpty == true ? title! : (latinTitle ?? ""));
  }

  String getDescription([BuildContext? context]) {
    return _isEnglish(context)
        ? (latinDesc?.isNotEmpty == true ? latinDesc! : (description ?? ""))
        : (description?.isNotEmpty == true ? description! : (latinDesc ?? ""));
  }

  String getFormattedDate(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat(
      "dd MMM yyyy • hh:mm a",
      locale,
    ).format(date!);
  }
}
