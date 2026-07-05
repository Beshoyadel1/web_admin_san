
import '../../../../../../../features/accounts_management/data/model/get_provider_balance_details_model/provider_balance_details_model.dart';

abstract class ProviderBalanceState {}

class ProviderBalanceInitial extends ProviderBalanceState {}

class ProviderBalanceLoading extends ProviderBalanceState {}

class ProviderBalanceSuccess extends ProviderBalanceState {
  final ProviderBalanceDetailsModel model;

  ProviderBalanceSuccess(this.model);
}

class ProviderBalanceError extends ProviderBalanceState {
  final String message;

  ProviderBalanceError(this.message);
}