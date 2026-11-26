import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/feature/accounts_management_page/data/request/get_wallet_balance_request/get_wallet_balance_request.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/wallet_balance_cubit/wallet_balance_state.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/networking/network.dart';
import '../../../../../../core/networking/failures.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';

class WalletBalanceCubit extends Cubit<WalletBalanceState> {
  WalletBalanceCubit() : super(WalletBalanceInitial());

  Future<void> getWalletBalance(
      {required ProviderDetailsRequest providerDetailsRequest}) async {
    emit(WalletBalanceLoading());

    try {
      final request = GetWalletBalanceRequest(
        userId: providerDetailsRequest.id ?? 5,
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
