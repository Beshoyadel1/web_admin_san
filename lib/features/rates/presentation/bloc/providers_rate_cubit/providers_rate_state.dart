import 'package:web_admin_san/features/rates/data/model/get_providers_basic_rate_models/get_providers_basic_rate_models.dart';

abstract class ProvidersRateState {}

class ProvidersRateInitial extends ProvidersRateState {}

class ProvidersRateLoading extends ProvidersRateState {}

class ProvidersRateSuccess extends ProvidersRateState {
  final List<ProviderRateModel> providers;

  ProvidersRateSuccess(this.providers);
}

class ProvidersRateError extends ProvidersRateState {
  final String message;

  ProvidersRateError(this.message);
}