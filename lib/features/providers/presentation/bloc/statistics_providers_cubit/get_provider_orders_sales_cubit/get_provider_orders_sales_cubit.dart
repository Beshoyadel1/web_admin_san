import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:web_admin_san/features/order_services/data/request/get_provider_orders_sales_request/get_provider_orders_sales_request.dart';
import 'package:web_admin_san/features/providers/data/datasource/statistics_providers_datasource/get_provider_orders_sales_datasource/get_provider_orders_sales_repository.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_state.dart';

class GetProviderOrdersSalesCubit
    extends Cubit<GetProviderOrdersSalesState> {

  GetProviderOrdersSalesCubit()
      : super(GetProviderOrdersSalesInitial());

  static GetProviderOrdersSalesCubit get(context) =>
      BlocProvider.of(context);

  Future<void> getProviderOrdersSales({required int providerId}) async {
    if (isClosed) return;

    emit(GetProviderOrdersSalesLoading());

    final result = await getProviderOrdersSalesFunction(
      request: GetProviderOrdersSalesRequest(
        providerId: providerId,
      ),
    );

    if (isClosed) return;

    if (result != null) {
      emit(GetProviderOrdersSalesSuccess(result));
    } else {
      emit(GetProviderOrdersSalesError("Error loading data"));
    }
  }
}