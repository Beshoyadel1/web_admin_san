class GetProviderServiceStatisticsRequest {
  final int? providerId;
  final DateTime? startDate;
  final DateTime? endDate;

  GetProviderServiceStatisticsRequest({
    this.providerId,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId ?? 0,
      if (startDate != null) "startDate": startDate!.toIso8601String(),
      if (endDate != null) "endDate": endDate!.toIso8601String(),
    };
  }
}
