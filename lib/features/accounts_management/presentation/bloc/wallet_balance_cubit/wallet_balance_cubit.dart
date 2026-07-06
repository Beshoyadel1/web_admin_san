import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import '../../../../../../../features/accounts_management/data/request/get_wallet_balance_request/get_wallet_balance_request.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/wallet_balance_cubit/wallet_balance_state.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';

class WalletBalanceCubit extends Cubit<WalletBalanceState> {
  WalletBalanceCubit() : super(WalletBalanceInitial());

  Future<void> getWalletBalance(
  {
    required ProviderDetailsRequest providerDetailsRequest
}
      ) async {

    emit(WalletBalanceLoading());

    try {

      final request = GetWalletBalanceRequest(
        userId: providerDetailsRequest.id??5,
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