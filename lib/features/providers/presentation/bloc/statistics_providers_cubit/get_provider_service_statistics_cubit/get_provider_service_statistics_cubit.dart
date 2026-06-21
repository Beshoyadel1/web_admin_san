import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:web_admin_san/features/order_services/data/request/get_provider_service_statistics_request/get_provider_service_statistics_request.dart';
import 'package:web_admin_san/features/providers/data/datasource/statistics_providers_datasource/get_provider_service_statistics_data_source/get_provider_service_statistics_repository.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_state.dart';

class GetProviderServiceStatisticsCubit
    extends Cubit<GetProviderServiceStatisticsState> {

  GetProviderServiceStatisticsCubit()
      : super(GetProviderServiceStatisticsInitial());

  static GetProviderServiceStatisticsCubit get(context) =>
      BlocProvider.of(context);

  Future<void> getProviderServiceStatistics({required int providerId}) async {
    if (isClosed) return;

    emit(GetProviderServiceStatisticsLoading());

    if (isClosed) return;

    final result = await getProviderServiceStatisticsFunction(
      request: GetProviderServiceStatisticsRequest(
        providerId: providerId,
      ),
    );

    if (isClosed) return;

    if (result != null) {
      emit(GetProviderServiceStatisticsSuccess(result));
    } else {
      emit(GetProviderServiceStatisticsError("Error loading data"));
    }
  }
}