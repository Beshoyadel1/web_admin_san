import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/statistics_page/data/request/get_provider_orders_sales_request/get_provider_orders_sales_request.dart';
import 'package:web_admin_san/feature/providers_page/data/datasource/statistics_providers_datasource/get_provider_orders_sales_datasource/get_provider_orders_sales_repository.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_state.dart';

class GetProviderOrdersSalesCubit extends Cubit<GetProviderOrdersSalesState> {
  GetProviderOrdersSalesCubit() : super(GetProviderOrdersSalesInitial());

  static GetProviderOrdersSalesCubit get(context) => BlocProvider.of(context);

  Future<void> getProviderOrdersSales({
    required int providerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (isClosed) return;

    emit(GetProviderOrdersSalesLoading());

    final result = await getProviderOrdersSalesFunction(
      request: GetProviderOrdersSalesRequest(
        providerId: providerId,
        startDate: startDate,
        endDate: endDate,
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
