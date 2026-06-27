class GetCompanyDriversRequest {
  final int? companyId;

  GetCompanyDriversRequest({
    this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      "companyId": companyId??1,
    };
  }
}