class GetCompanyDriversRequest {
  final int companyId;
  final bool? includeNotActive;

  GetCompanyDriversRequest({
    required this.companyId,
    this.includeNotActive,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      "companyId": companyId,
      if (includeNotActive != null) "includeNotActive": includeNotActive,
    };
  }

  Map<String, dynamic> toJson() => toQueryParams();
}
