import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/order_services/data/datasource/get_admin_dashboard_statistics_datasource/get_admin_dashboard_statistics_datasource.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';


class AdminDashboardStatisticsCubit
    extends Cubit<AdminDashboardStatisticsState> {
  AdminDashboardStatisticsCubit() : super(AdminDashboardStatisticsInitial());

  Future<void> getStatistics() async {
    emit(AdminDashboardStatisticsLoading());

    final data = await getAdminDashboardStatisticsFunction();

    if (data != null) {
      emit(AdminDashboardStatisticsSuccess(data));
    } else {
      emit(AdminDashboardStatisticsError());
    }
  }
}