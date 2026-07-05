import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/features/providers/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import '../../../../../../../features/accounts_management/data/datasource/get_provider_balance_details_datasource/get_provider_balance_details_repository.dart';
import '../../../../../../../features/accounts_management/data/request/get_provider_balance_details_request/get_provider_balance_details_request.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_state.dart';
import '../../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';


class ProviderBalanceCubit extends Cubit<ProviderBalanceState> {
  ProviderBalanceCubit() : super(ProviderBalanceInitial());

  Future<void> getBalanceDetails(
  {
    required GetAllProvidersModels providerDetailsRequest
}
      ) async {
    emit(ProviderBalanceLoading());

    try {

      final request = GetProviderBalanceDetailsRequest(
        providerId: providerDetailsRequest.providerId??5,
      );

      final data = await getProviderBalanceDetailsFunction(
        request: request,
      );

      if (data == null) {
        emit(ProviderBalanceError("No data"));
        return;
      }

      emit(ProviderBalanceSuccess(data));

    } catch (e) {
      emit(ProviderBalanceError(e.toString()));
    }
  }
}