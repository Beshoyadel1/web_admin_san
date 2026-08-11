class AdminDetailsRequest {
  final int? id;
  final String? jobname;
  final String? joblatinname;
  final AdminPermissionsRequest? permissions;

  const AdminDetailsRequest({
    this.id,
    this.jobname,
    this.joblatinname,
    this.permissions,
  });

  factory AdminDetailsRequest.fromJson(
      Map<String, dynamic> json,
      ) =>
      AdminDetailsRequest(
        id: json["id"],
        jobname: json["jobname"],
        joblatinname: json["joblatinname"],
        permissions: json["permissions"] != null
            ? AdminPermissionsRequest.fromJson(
          json["permissions"],
        )
            : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id ?? 0,
    "jobname": jobname ?? "",
    "joblatinname": joblatinname ?? "",
    "permissions": permissions?.toJson() ??
        const AdminPermissionsRequest().toJson(),
  };
}
class AdminPermissionsRequest {
  final int? adminid;
  final bool? statistic;
  final bool? orders;
  final bool? providers;
  final bool? companies;
  final bool? users;
  final bool? finances;
  final bool? packages;
  final bool? approvals;
  final bool? ranks;
  final bool? support;
  final bool? admins;
  final bool? banners;
  final bool? coupons;
  final bool? harage;
  final bool? insurance;

  const AdminPermissionsRequest({
    this.adminid,
    this.statistic,
    this.orders,
    this.providers,
    this.companies,
    this.users,
    this.finances,
    this.packages,
    this.approvals,
    this.ranks,
    this.support,
    this.admins,
    this.banners,
    this.coupons,
    this.harage,
    this.insurance,
  });

  factory AdminPermissionsRequest.fromJson(
      Map<String, dynamic> json,
      ) =>
      AdminPermissionsRequest(
        adminid: json["adminid"],
        statistic: json["statistic"],
        orders: json["orders"],
        providers: json["providers"],
        companies: json["companies"],
        users: json["users"],
        finances: json["finances"],
        packages: json["packages"],
        approvals: json["approvals"],
        ranks: json["ranks"],
        support: json["support"],
        admins: json["admins"],
        banners: json["banners"],
        coupons: json["coupons"],
        harage: json["harage"],
        insurance: json["insurance"],
      );

  Map<String, dynamic> toJson() => {
    "adminid": adminid ?? 0,
    "statistic": statistic ?? false,
    "orders": orders ?? false,
    "providers": providers ?? false,
    "companies": companies ?? false,
    "users": users ?? false,
    "finances": finances ?? false,
    "packages": packages ?? false,
    "approvals": approvals ?? false,
    "ranks": ranks ?? false,
    "support": support ?? false,
    "admins": admins ?? false,
    "banners": banners ?? false,
    "coupons": coupons ?? false,
    "harage": harage ?? false,
    "insurance": insurance ?? false,
  };
}