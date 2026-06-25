class GetProviderOrdersRequest {
  final int? providerId;
  final int? employeeId;
  final int? pageNumber;
  final int? orderType;
  final int? serviceId;
  final int? companyId;

  GetProviderOrdersRequest({
     this.providerId,
     this.employeeId,
     this.pageNumber,
     this.orderType,
     this.serviceId,
    this.companyId
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      "employeeId": employeeId,
      "pageNumber": pageNumber,
      "orderType": orderType,
      "ServiceId": serviceId,
      "companyId": companyId,
    };
  }
}