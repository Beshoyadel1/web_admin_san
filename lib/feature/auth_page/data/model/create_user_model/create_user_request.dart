import 'dart:convert';
import 'dart:typed_data';

import 'admin_details_request.dart';
import 'company_details_request.dart';
import 'driver_details_request.dart';
import 'provider_details_request.dart';

class CreateUserRequest {
  final int? userid;
  final String? username;
  final String? phone;
  final String? email;
  final String? password;
  final int? gender;
  final DateTime? birthDate;
  // int? get age => birthDate == null
  //     ? null
  //     : ((DateTime.now().difference(birthDate!).inDays) / 365.25).floor();
  final int? type;
  final String? nationality;
  final bool? isActive;
  final DateTime? joinDate;
  final String? referralCode;
  final Uint8List? image;
  final String? fcmToken;
  final int? currentCarId;

  final AdminDetailsRequest? adminDetails;
  final ProviderDetailsRequest? providerDetails;
  //final EmployeeWrapperRequest? employeeDetails;
  final CompanyDetailsRequest? companyDetails;
  final DriverDetailsRequest? driverDetails;

  bool isSameData(CreateUserRequest other) {
    return jsonEncode(toJson()) == jsonEncode(other.toJson());
  }

  const CreateUserRequest({
    this.userid,
    this.username,
    this.phone,
    this.email,
    this.password,
    this.gender,
    this.birthDate,
    this.type,
    this.nationality,
    this.isActive,
    this.joinDate,
    this.referralCode,
    this.image,
    this.fcmToken,
    this.currentCarId,
    this.adminDetails,
    this.providerDetails,
    // this.employeeDetails,
    this.companyDetails,
    this.driverDetails,
  });

  CreateUserRequest copyWith({
    int? userid,
    String? username,
    String? phone,
    String? email,
    String? password,
    int? gender,
    DateTime? birthDate,
    int? type,
    String? nationality,
    bool? isActive,
    DateTime? joinDate,
    String? referralCode,
    Uint8List? image,
    String? fcmToken,
    int? currentCarId,
    AdminDetailsRequest? adminDetails,
    ProviderDetailsRequest? providerDetails,
    CompanyDetailsRequest? companyDetails,
    DriverDetailsRequest? driverDetails,
  }) {
    return CreateUserRequest(
      userid: userid ?? this.userid,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      type: type ?? this.type,
      nationality: nationality ?? this.nationality,
      isActive: isActive ?? this.isActive,
      joinDate: joinDate ?? this.joinDate,
      referralCode: referralCode ?? this.referralCode,
      image: image ?? this.image,
      fcmToken: fcmToken ?? this.fcmToken,
      currentCarId: currentCarId ?? this.currentCarId,
      adminDetails: adminDetails ?? this.adminDetails,
      providerDetails: providerDetails ?? this.providerDetails,
      companyDetails: companyDetails ?? this.companyDetails,
      driverDetails: driverDetails ?? this.driverDetails,
    );
  }

  factory CreateUserRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateUserRequest(
      userid: json["userid"] ?? json["USERID"] ?? json["UserId"],
      username: json["username"] ?? json["USERNAME"] ?? json["UserName"],
      phone: json["phone"] ?? json["PHONE"] ?? json["Phone"],
      email: json["email"] ?? json["EMAIL"] ?? json["Email"],
      password: json["password"] ?? json["PASSWORD"] ?? json["Password"],
      gender: json["gender"] ?? json["GENDER"] ?? json["Gender"],
      birthDate: (json["birthDate"] ??
                  json["birthdate"] ??
                  json["BIRTHDATE"] ??
                  json["BirthDate"]) !=
              null
          ? DateTime.tryParse(
              (json["birthDate"] ??
                      json["birthdate"] ??
                      json["BIRTHDATE"] ??
                      json["BirthDate"])
                  .toString(),
            )
          : null,
      type: json["type"] ?? json["TYPE"] ?? json["Type"],
      nationality:
          json["nationality"] ?? json["NATIONALITY"] ?? json["Nationality"],
      isActive: json["isactive"] ?? json["ISACTIVE"] ?? json["IsActive"],
      referralCode:
          json["referralcode"] ?? json["REFERRALCODE"] ?? json["ReferralCode"],
      fcmToken: json["fcmtoken"] ??
          json["FCMTOKEN"] ??
          json["fcmToken"] ??
          json["FcmToken"],
      currentCarId: json["defaultcarid"] ??
          json["DEFAULTCARID"] ??
          json["currentcarid"] ??
          json["CURRENTCARID"],
      joinDate:
          (json["joindate"] ?? json["JOINDATE"] ?? json["JoinDate"]) != null
              ? DateTime.tryParse(
                  (json["joindate"] ?? json["JOINDATE"] ?? json["JoinDate"])
                      .toString(),
                )
              : null,
      image: (json["image"] ?? json["IMAGE"] ?? json["Image"]) != null
          ? base64Decode(
              (json["image"] ?? json["IMAGE"] ?? json["Image"]).toString(),
            )
          : null,
      adminDetails: (json["adminDetails"] ?? json["AdminDetails"]) != null
          ? AdminDetailsRequest.fromJson(
              json["adminDetails"] ?? json["AdminDetails"],
            )
          : null,
      providerDetails:
          (json["providerDetails"] ?? json["ProviderDetails"]) != null
              ? ProviderDetailsRequest.fromJson(
                  json["providerDetails"] ?? json["ProviderDetails"],
                )
              : null,
      companyDetails: (json["companyDetails"] ?? json["CompanyDetails"]) != null
          ? CompanyDetailsRequest.fromJson(
              json["companyDetails"] ?? json["CompanyDetails"],
            )
          : null,
      driverDetails: (json["driverDetails"] ?? json["DriverDetails"]) != null
          ? DriverDetailsRequest.fromJson(
              json["driverDetails"] ?? json["DriverDetails"],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final cleanToken = fcmToken?.trim();
    return {
      "USERID": userid ?? 0,
      "USERNAME": username ?? "",
      "PHONE": phone ?? "",
      "EMAIL": email ?? "",
      "PASSWORD": password ?? "",
      "GENDER": gender ?? 0,
      "BIRTHDATE": birthDate?.toIso8601String(),
      "TYPE": type ?? 0,
      "NATIONALITY": nationality ?? "",
      "ISACTIVE": isActive ?? true,
      "JOINDATE": (joinDate ?? DateTime.now()).toIso8601String(),
      "REFERRALCODE": referralCode ?? "",
      "FCMTOKEN": cleanToken ?? "",
      "DEFAULTCARID": currentCarId ?? 0,
      "IMAGE": image != null ? base64Encode(image!) : null,
      "AdminDetails": adminDetails?.toJson(),
      "ProviderDetails": providerDetails?.toJson(),
      "CompanyDetails": companyDetails?.toJson(),
      "DriverDetails": driverDetails?.toJson(),
    };
  }
}
