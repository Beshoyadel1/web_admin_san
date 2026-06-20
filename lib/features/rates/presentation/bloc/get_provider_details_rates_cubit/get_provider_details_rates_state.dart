
import 'package:web_admin_san/features/rates/data/model/get_provider_details_rates_model/get_provider_details_rates_model.dart';

abstract class GetProviderDetailsRatesState {}

class GetProviderDetailsRatesInitial
    extends GetProviderDetailsRatesState {}

class GetProviderDetailsRatesLoading
    extends GetProviderDetailsRatesState {}

class GetProviderDetailsRatesSuccess
    extends GetProviderDetailsRatesState {
  final ProviderDetailsRatesModel model;

  GetProviderDetailsRatesSuccess(
      this.model,
      );
}

class GetProviderDetailsRatesError
    extends GetProviderDetailsRatesState {
  final String message;

  GetProviderDetailsRatesError(
      this.message,
      );
}