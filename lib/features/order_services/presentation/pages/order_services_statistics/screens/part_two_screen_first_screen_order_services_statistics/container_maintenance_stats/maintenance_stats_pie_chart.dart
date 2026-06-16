import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';

class MaintenanceStatsPieChart extends StatelessWidget {
  final int userCarsCount;
  final int companyCarsCount;

  const MaintenanceStatsPieChart({
    super.key,
    required this.userCarsCount,
    required this.companyCarsCount,
  });

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(
        AppLanguageKeys.userCarsCount,
        userCarsCount.toDouble(),
        AppColors.orangeColor,
      ),
      ChartData(
        AppLanguageKeys.companyCarsCount,
        companyCarsCount.toDouble(),
        AppColors.seaBlueColor,
      ),
    ];

    return SfCircularChart(
      legend: const Legend(isVisible: false),
      series: <PieSeries<ChartData, String>>[
        PieSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.title,
          yValueMapper: (ChartData data, _) => data.value,
          pointColorMapper: (ChartData data, _) => data.color,
          dataLabelSettings:
          const DataLabelSettings(isVisible: false),
        ),
      ],
    );
  }
}

class ChartData {
  final String title;
  final double value;
  final Color color;

  ChartData(this.title, this.value, this.color);
}