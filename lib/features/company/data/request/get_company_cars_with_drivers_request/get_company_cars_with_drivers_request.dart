class GetCompanyCarsWithDriversRequest {
  final int? companyId;

  GetCompanyCarsWithDriversRequest({
    this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      "companyId": companyId??1,
    };
  }
}