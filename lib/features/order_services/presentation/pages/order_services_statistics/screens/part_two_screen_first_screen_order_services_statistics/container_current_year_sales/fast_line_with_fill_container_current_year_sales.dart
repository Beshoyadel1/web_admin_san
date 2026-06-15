import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/features/order_services/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_cubit.dart';
import 'package:web_admin_san/features/order_services/presentation/cubit/admin_dashboard_statistics_cubit/admin_dashboard_statistics_state.dart';

class FastLineWithFillContainerCurrentYearSales
    extends StatelessWidget {
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
                xValueMapper: (e, _) => e.label,
                yValueMapper: (e, _) => e.value,
                color: Colors.pink.withOpacity(0.3),
                borderColor: Colors.transparent,
              ),
              FastLineSeries<SalesItem, String>(
                dataSource: currentYearSales,
                xValueMapper: (e, _) => e.label,
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