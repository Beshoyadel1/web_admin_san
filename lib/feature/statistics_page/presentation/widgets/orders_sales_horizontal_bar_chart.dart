import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/utils/chart_date_localizer.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_admin_dashboard_statistics_model/get_admin_dashboard_statistics_model.dart';

class OrdersSalesHorizontalBarChart extends StatelessWidget {
  final MonthlySalesComparison comparison;

  const OrdersSalesHorizontalBarChart({
    super.key,
    required this.comparison,
  });

  @override
  Widget build(BuildContext context) {
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
            'مبيعات الطلبات',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendDot(color: AppColors.chartOrange),
                  SizedBox(width: 6),
                  Text(
                    'مبيعات السنة الحالية',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.darkGreyColor),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendDot(color: AppColors.chartGrey),
                  SizedBox(width: 6),
                  Text(
                    'مبيعات السنة السابقة',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.darkGreyColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: SfCartesianChart(
              isTransposed: true,
              plotAreaBorderWidth: 0,
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                labelStyle:
                    TextStyle(fontSize: 10, color: AppColors.darkGreyColor),
                isInversed: true,
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: AppColors.lightGreyColor.withValues(alpha: 0.5),
                ),
                labelFormat: 'SAR {value}',
                labelStyle: const TextStyle(
                    fontSize: 9, color: AppColors.darkGreyColor),
              ),
              series: <CartesianSeries>[
                ColumnSeries<SalesItem, String>(
                  name: 'السنة السابقة',
                  dataSource: comparison.lastYearSales,
                  xValueMapper: (SalesItem item, _) =>
                      ChartDateLocalizer.localize(item.label, context),
                  yValueMapper: (SalesItem item, _) => item.value,
                  color: AppColors.chartGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  width: 0.6,
                ),
                ColumnSeries<SalesItem, String>(
                  name: 'السنة الحالية',
                  dataSource: comparison.currentYearSales,
                  xValueMapper: (SalesItem item, _) =>
                      ChartDateLocalizer.localize(item.label, context),
                  yValueMapper: (SalesItem item, _) => item.value,
                  color: AppColors.chartOrange,
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  width: 0.6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
