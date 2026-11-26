import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/error_state_view.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/maintenance_cars_pie_chart.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/most_requested_services_donut_chart.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/orders_sales_horizontal_bar_chart.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/recent_orders_list_widget.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/sales_and_commission_spline_chart.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/statistics_summary_cards_grid.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/most_requested_services_cubit/most_requested_services_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/sales_commission_cubit/sales_commission_cubit.dart';

typedef OrderServicesStatistics = StatisticsPage;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AdminDashboardStatisticsCubit()..getStatistics(),
        ),
        BlocProvider(
          create: (_) => SalesCommissionCubit()..fetchSalesCommission(),
        ),
        BlocProvider(
          create: (_) =>
              MostRequestedServicesCubit()..fetchMostRequestedServices(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.orangeColor,
            onRefresh: () async {
              await Future.wait([
                context.read<AdminDashboardStatisticsCubit>().getStatistics(),
                context.read<SalesCommissionCubit>().fetchSalesCommission(),
                context
                    .read<MostRequestedServicesCubit>()
                    .fetchMostRequestedServices(),
              ]);
            },
            child: Scaffold(
              backgroundColor: AppColors.scaffoldColor,
              body: SafeArea(
                child: BlocBuilder<AdminDashboardStatisticsCubit,
                    AdminDashboardStatisticsState>(
                  builder: (context, state) {
                    if (state is AdminDashboardStatisticsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orangeColor,
                        ),
                      );
                    }

                    if (state is AdminDashboardStatisticsError) {
                      return ErrorStateView(
                        message: state.error,
                        onRetry: () {
                          context
                              .read<AdminDashboardStatisticsCubit>()
                              .getStatistics();
                        },
                      );
                    }

                    if (state is AdminDashboardStatisticsSuccess) {
                      final data = state.data;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 1050;

                          return Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(20),
                              child: isWide
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Main Content: 6 Summary Cards, Spline Line Chart, Recent Orders
                                        // Placed at Start: Right in RTL, Left in LTR
                                        Expanded(
                                          child: Column(
                                            children: [
                                              StatisticsSummaryCardsGrid(
                                                summary: data.summary,
                                              ),
                                              const SizedBox(height: 16),
                                              const SalesAndCommissionSplineChart(),
                                              const SizedBox(height: 16),
                                              RecentOrdersListWidget(
                                                orders: data.recentOrders,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Side Column: Bar chart, Donut chart, Pie chart
                                        // Placed at End: Left in RTL, Right in LTR
                                        SizedBox(
                                          width: 420,
                                          child: Column(
                                            children: [
                                              OrdersSalesHorizontalBarChart(
                                                comparison:
                                                    data.monthlySalesComparison,
                                              ),
                                              const SizedBox(height: 16),
                                              const MostRequestedServicesDonutChart(),
                                              const SizedBox(height: 16),
                                              MaintenanceCarsPieChart(
                                                stats: data.maintenanceStats,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        StatisticsSummaryCardsGrid(
                                          summary: data.summary,
                                        ),
                                        const SizedBox(height: 16),
                                        const SalesAndCommissionSplineChart(),
                                        const SizedBox(height: 16),
                                        RecentOrdersListWidget(
                                          orders: data.recentOrders,
                                        ),
                                        const SizedBox(height: 16),
                                        OrdersSalesHorizontalBarChart(
                                          comparison:
                                              data.monthlySalesComparison,
                                        ),
                                        const SizedBox(height: 16),
                                        const MostRequestedServicesDonutChart(),
                                        const SizedBox(height: 16),
                                        MaintenanceCarsPieChart(
                                          stats: data.maintenanceStats,
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
