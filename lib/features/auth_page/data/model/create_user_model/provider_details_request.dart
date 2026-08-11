import 'dart:convert';
import 'dart:typed_data';

class ProviderDetailsRequest {
  final int? id;
  final String? name;
  final String? latinname;
  final String? description;
  final String? latindesc;
  final int? provid;
  final String? cr;
  final String? vatno;
  final int? packageid;

  final DateTime? subscriptionstartdate;
  final DateTime? subscriptionenddate;

  final String? iban;
  final String? nationaladdress;

  final Uint8List? crimage;
  final Uint8List? vatnoimage;
  final Uint8List? ibanimage;

  final bool? isApproved;

  final dynamic approvalInfo;

  const ProviderDetailsRequest({
    this.id,
    this.name,
    this.latinname,
    this.description,
    this.latindesc,
    this.provid,
    this.cr,
    this.vatno,
    this.packageid,
    this.subscriptionstartdate,
    this.subscriptionenddate,
    this.iban,
    this.nationaladdress,
    this.crimage,
    this.vatnoimage,
    this.ibanimage,
    this.isApproved,
    this.approvalInfo,
  });

  factory ProviderDetailsRequest.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProviderDetailsRequest(
      id: json["id"],
      name: json["name"],
      latinname: json["latinname"],
      description: json["description"],
      latindesc: json["latindesc"],
      provid: json["provid"],
      cr: json["cr"],
      vatno: json["vatno"],
      packageid: json["packageid"],

      subscriptionstartdate:
      json["subscriptionstartdate"] != null
          ? DateTime.tryParse(
        json["subscriptionstartdate"].toString(),
      )
          : null,

      subscriptionenddate:
      json["subscriptionenddate"] != null
          ? DateTime.tryParse(
        json["subscriptionenddate"].toString(),
      )
          : null,

      iban: json["iban"],
      nationaladdress: json["nationaladdress"],

      crimage: json["crimage"] != null
          ? base64Decode(json["crimage"])
          : null,

      vatnoimage: json["vatnoimage"] != null
          ? base64Decode(json["vatnoimage"])
          : null,

      ibanimage: json["ibanimage"] != null
          ? base64Decode(json["ibanimage"])
          : null,

      isApproved: json["isApproved"],

      approvalInfo: json["approvalInfo"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? 0,
      "name": name ?? "",
      "latinname": latinname ?? "",
      "description": description ?? "",
      "latindesc": latindesc ?? "",
      "provid": provid ?? 0,
      "cr": cr ?? "",
      "vatno": vatno ?? "",
      "packageid": packageid ?? 0,

      "subscriptionstartdate":
      subscriptionstartdate?.toIso8601String(),

      "subscriptionenddate":
      subscriptionenddate?.toIso8601String(),

      "iban": iban ?? "",
      "nationaladdress": nationaladdress ?? "",

      "crimage": crimage != null
          ? base64Encode(crimage!)
          : null,

      "vatnoimage": vatnoimage != null
          ? base64Encode(vatnoimage!)
          : null,

      "ibanimage": ibanimage != null
          ? base64Encode(ibanimage!)
          : null,

      "isApproved": isApproved ?? false,

      "approvalInfo": approvalInfo,
    };
  }
}