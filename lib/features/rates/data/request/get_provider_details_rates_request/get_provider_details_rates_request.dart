class GetProviderDetailsRatesRequest {
  final int providerId;
  final int serviceId;

  GetProviderDetailsRatesRequest({
    required this.providerId,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      "serviceId": serviceId,
    };
  }
}