import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/utils/chart_date_localizer.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';

class FastLineWithFillContainerCurrentYearSales extends StatelessWidget {
  FastLineWithFillContainerCurrentYearSales({super.key});

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
    zoomMode: ZoomMode.x,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardStatisticsCubit,
        AdminDashboardStatisticsState>(
      builder: (context, state) {
        if (state is! AdminDashboardStatisticsSuccess) {
          return const SizedBox();
        }

        final currentYearSales =
            state.data.monthlySalesComparison.currentYearSales;

        return SizedBox(
          height: 150,
          child: SfCartesianChart(
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(),
            series: <CartesianSeries>[
              AreaSeries<SalesItem, String>(
                dataSource: currentYearSales,
                xValueMapper: (e, _) =>
                    ChartDateLocalizer.localize(e.label, context),
                yValueMapper: (e, _) => e.value,
                color: AppColors.orangeColor.withValues(alpha: 0.15),
                borderColor: AppColors.transparent,
              ),
              FastLineSeries<SalesItem, String>(
                dataSource: currentYearSales,
                xValueMapper: (e, _) =>
                    ChartDateLocalizer.localize(e.label, context),
                yValueMapper: (e, _) => e.value,
                color: AppColors.orangeColor,
                width: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
