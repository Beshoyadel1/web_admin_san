import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/statistics_page/data/datasource/statistics_charts_datasource.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/sales_commission_model.dart';
import 'sales_commission_state.dart';

class SalesCommissionCubit extends Cubit<SalesCommissionState> {
  SalesCommissionCubit() : super(SalesCommissionInitial());

  DateTime? startDate;
  DateTime? endDate;

  Future<void> fetchSalesCommission({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    startDate = fromDate ?? startDate;
    endDate = toDate ?? endDate;

    emit(SalesCommissionLoading());
    try {
      final result = await StatisticsChartsDatasource.getSalesAndCommission(
        startDate: startDate,
        endDate: endDate,
      );

      if (isClosed) return;

      if (result != null) {
        emit(SalesCommissionSuccess(
          data: result,
          startDate: startDate,
          endDate: endDate,
        ));
      } else {
        // Fallback default points if empty
        emit(SalesCommissionSuccess(
          data: AdminSalesAndCommissionModel(
            totalSales: 0,
            totalCommission: 0,
            chartPoints: [],
          ),
          startDate: startDate,
          endDate: endDate,
        ));
      }
    } catch (e) {
      if (isClosed) return;
      emit(SalesCommissionError(e.toString()));
    }
  }
}
