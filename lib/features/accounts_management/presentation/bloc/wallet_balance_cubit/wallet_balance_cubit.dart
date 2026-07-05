import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/features/providers/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import '../../../../../../../features/accounts_management/data/request/get_wallet_balance_request/get_wallet_balance_request.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/wallet_balance_cubit/wallet_balance_state.dart';
import '../../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';

class WalletBalanceCubit extends Cubit<WalletBalanceState> {
  WalletBalanceCubit() : super(WalletBalanceInitial());

  Future<void> getWalletBalance(
  {
    required GetAllProvidersModels providerDetailsRequest
}
      ) async {

    emit(WalletBalanceLoading());

    try {

      final request = GetWalletBalanceRequest(
        userId: providerDetailsRequest.providerId??5,
        userType: UserType.providerUser,
      );

      final response = await Network.postDataWithBodyAndParams(
        {},
        request.toJson(),
        ApiLink.getWalletBalance,
      );

      final data = response.data['data'];

      final balance = (data ?? 0).toDouble();

      emit(WalletBalanceSuccess(balance));

    } catch (e) {

      final errorMessage = e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString();

      AppSnackBar.showError(errorMessage);

      emit(WalletBalanceError(errorMessage));
    }
  }
}