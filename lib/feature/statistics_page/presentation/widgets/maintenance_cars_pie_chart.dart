import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';

class MaintenanceCarsPieChart extends StatelessWidget {
  final MaintenanceStats stats;

  const MaintenanceCarsPieChart({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final userCars = stats.userCarsCount > 0 ? stats.userCarsCount : 300;
    final companyCars =
        stats.companyCarsCount > 0 ? stats.companyCarsCount : 100;

    final chartData = [
      _PieData('سيارات المستخدمين', userCars.toDouble(), AppColors.chartOrange),
      _PieData('سيارات الشركات', companyCars.toDouble(), AppColors.chartTeal),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.lightGreyColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'احصائية عدد المستخدمين والشركات للصيانة',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Pie Chart
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 160,
                  child: SfCircularChart(
                    margin: EdgeInsets.zero,
                    series: <CircularSeries>[
                      PieSeries<_PieData, String>(
                        dataSource: chartData,
                        xValueMapper: (_PieData data, _) => data.label,
                        yValueMapper: (_PieData data, _) => data.value,
                        pointColorMapper: (_PieData data, _) => data.color,
                        radius: '90%',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Legends
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(
                      color: AppColors.chartOrange,
                      title: 'سيارات المستخدمين',
                      subtitle: '$userCars سيارة',
                    ),
                    const SizedBox(height: 16),
                    _buildLegendItem(
                      color: AppColors.chartTeal,
                      title: 'سيارات الشركات',
                      subtitle: '$companyCars سيارة',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.darkGreyColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PieData {
  final String label;
  final double value;
  final Color color;

  _PieData(this.label, this.value, this.color);
}
