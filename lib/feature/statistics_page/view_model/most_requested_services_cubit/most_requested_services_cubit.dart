import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/statistics_page/data/datasource/statistics_charts_datasource.dart';
import 'most_requested_services_state.dart';

class MostRequestedServicesCubit extends Cubit<MostRequestedServicesState> {
  MostRequestedServicesCubit() : super(MostRequestedServicesInitial());

  DateTime? startDate;
  DateTime? endDate;

  Future<void> fetchMostRequestedServices({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    startDate = fromDate ?? startDate;
    endDate = toDate ?? endDate;

    emit(MostRequestedServicesLoading());
    try {
      final result = await StatisticsChartsDatasource.getMostRequestedServices(
        startDate: startDate,
        endDate: endDate,
      );

      if (isClosed) return;

      if (result != null && result.isNotEmpty) {
        emit(MostRequestedServicesSuccess(
          services: result,
          startDate: startDate,
          endDate: endDate,
        ));
      } else {
        emit(MostRequestedServicesSuccess(
          services: const [],
          startDate: startDate,
          endDate: endDate,
        ));
      }
    } catch (e) {
      if (isClosed) return;
      emit(MostRequestedServicesError(e.toString()));
    }
  }
}
