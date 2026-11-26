class GetOrdersRequest {
  final int? pageNumber, orderType;
  final String? search;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? userType;

  GetOrdersRequest({
    this.pageNumber,
    this.orderType,
    this.search,
    this.startDate,
    this.endDate,
    this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber ?? 1,
      if (orderType != null) "orderType": orderType,
      if (search != null && search!.trim().isNotEmpty) "search": search!.trim(),
      if (startDate != null) "startDate": startDate!.toUtc().toIso8601String(),
      if (endDate != null) "endDate": endDate!.toUtc().toIso8601String(),
      if (userType != null) "userType": userType,
    };
  }
}
