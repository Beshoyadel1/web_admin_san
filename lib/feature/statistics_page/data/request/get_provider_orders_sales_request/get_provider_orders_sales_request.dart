class GetProviderOrdersSalesRequest {
  final int providerId;
  final DateTime? startDate;
  final DateTime? endDate;

  GetProviderOrdersSalesRequest({
    required this.providerId,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      if (startDate != null) "startDate": startDate!.toIso8601String(),
      if (endDate != null) "endDate": endDate!.toIso8601String(),
    };
  }
}
