import 'package:web_admin_san/features/order_services/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';

abstract class AdminDashboardStatisticsState {}

class AdminDashboardStatisticsInitial extends AdminDashboardStatisticsState {}

class AdminDashboardStatisticsLoading extends AdminDashboardStatisticsState {}

class AdminDashboardStatisticsSuccess extends AdminDashboardStatisticsState {
  final DashboardData data;

  AdminDashboardStatisticsSuccess(this.data);
}

class AdminDashboardStatisticsError extends AdminDashboardStatisticsState {}
