import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:web_admin_san/features/order_services/data/request/get_provider_total_rate_and_employee_and_balance_request/get_provider_total_rate_and_employee_and_balance_request.dart';
import 'package:web_admin_san/features/providers/data/datasource/statistics_providers_datasource/get_provider_total_rate_and_employee_and_balance_datasource/get_provider_total_rate_and_employee_and_balance_repository.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_state.dart';

class GetProviderTotalRateAndEmployeeAndBalanceCubit
    extends Cubit<GetProviderTotalRateAndEmployeeAndBalanceState> {

  GetProviderTotalRateAndEmployeeAndBalanceCubit()
      : super(GetProviderTotalRateAndEmployeeAndBalanceInitial());

  static GetProviderTotalRateAndEmployeeAndBalanceCubit get(context) =>
      BlocProvider.of(context);

  Future<void> getProviderTotalRateAndEmployeeAndBalance({required int providerId}) async {
    if (isClosed) return;

    emit(GetProviderTotalRateAndEmployeeAndBalanceLoading());


    if (isClosed) return;


    final result =
    await getProviderTotalRateAndEmployeeAndBalanceFunction(
      request: GetProviderTotalRateAndEmployeeAndBalanceRequest(
        providerId: providerId,
      ),
    );

    if (isClosed) return;

    if (result != null) {
      emit(GetProviderTotalRateAndEmployeeAndBalanceSuccess(result));
    } else {
      emit(GetProviderTotalRateAndEmployeeAndBalanceError("Error loading data"));
    }
  }
}