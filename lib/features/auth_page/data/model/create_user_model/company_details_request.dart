import 'dart:convert';
import 'dart:typed_data';

class CompanyDetailsRequest {
  final int? id;
  final String? name;
  final String? latinname;
  final String? vatno;
  final String? cr;
  final int? packageid;
  final Uint8List? vatimage,crimage,identityimage;

  const CompanyDetailsRequest({
    this.id,
    this.name,
    this.latinname,
    this.vatno,
    this.cr,
    this.packageid,
    this.vatimage,
    this.crimage,
    this.identityimage
  });

  factory CompanyDetailsRequest.fromJson(Map<String, dynamic> json) =>
      CompanyDetailsRequest(
        id: json["id"],
        name: json["name"],
        latinname: json["latinname"],
        vatno: json["vatno"],
        cr: json["cr"],
        packageid: json["packageid"],
        vatimage: json["vatimage"] != null ? base64Decode(json["vatimage"]) : null,
        crimage: json["crimage"] != null ? base64Decode(json["crimage"]) : null,
        identityimage: json["identityimage"] != null ? base64Decode(json["identityimage"]) : null,

      );

  Map<String, dynamic> toJson() => {
    "id": id??0,
    "name": name??"",
    "latinname": latinname??"",
    "vatno": vatno??"",
    "cr": cr??"",
    "packageid": packageid??0,
    "vatimage": vatimage != null ? base64Encode(vatimage!) : null,
    "crimage": crimage != null ? base64Encode(crimage!) : null,
    "identityimage": identityimage != null ? base64Encode(identityimage!) : null,
  };
}
