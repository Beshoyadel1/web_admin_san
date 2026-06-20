import '../../model/get_provider_details_rates_model/provider.dart';
import '../../model/get_provider_details_rates_model/service_rates.dart';

class ProviderDetailsRatesResponse {
  final Provider provider;
  final int rateCount;
  final int averageRate;
  final List<ServiceRates> rates;

  ProviderDetailsRatesResponse({
    required this.provider,
    required this.rateCount,
    required this.averageRate,
    required this.rates,
  });

  factory ProviderDetailsRatesResponse.fromJson(
      Map<String, dynamic> json) {

    final data =
        json['data'] as Map<String, dynamic>? ?? {};

    return ProviderDetailsRatesResponse(
      provider: data['provider'] != null
          ? Provider.fromJson(
          data['provider']
          as Map<String, dynamic>)
          : Provider.fromJson({}),

      rateCount:
      data['rateCount'] ?? 0,

      averageRate:
      data['averageRate'] ?? 0,

      rates:
      (data['rates'] as List<dynamic>?)
          ?.map((e) =>
          ServiceRates.fromJson(
              e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}