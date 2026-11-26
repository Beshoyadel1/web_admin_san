import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_main_service_statistics_model/data_points_model.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_state.dart';

class FastLineWithFill extends StatelessWidget {
  FastLineWithFill({super.key});

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enablePanning: true,
    zoomMode: ZoomMode.x,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
      builder: (context, state) {
        return SizedBox(
          height: 150,
          child: SfCartesianChart(
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(),
            series: <CartesianSeries>[
              AreaSeries<DataPointsModel, String>(
                dataSource: state.chartPoints,
                xValueMapper: (e, _) => e.label ?? '',
                yValueMapper: (e, _) => e.value ?? 0,
                color: Colors.pink.withOpacity(0.3),
                borderColor: Colors.transparent,
              ),
              FastLineSeries<DataPointsModel, String>(
                dataSource: state.chartPoints,
                xValueMapper: (e, _) => e.label ?? '',
                yValueMapper: (e, _) => e.value ?? 0,
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

class ChartData {
  ChartData(this.x, this.y);

  final DateTime x;
  final double y;
}
