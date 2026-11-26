import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/utils/chart_date_localizer.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/sales_commission_model.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/statistics_date_picker_field.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/sales_commission_cubit/sales_commission_cubit.dart';
import 'package:web_admin_san/feature/statistics_page/view_model/sales_commission_cubit/sales_commission_state.dart';

class SalesAndCommissionSplineChart extends StatelessWidget {
  const SalesAndCommissionSplineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCommissionCubit, SalesCommissionState>(
      builder: (context, state) {
        final cubit = context.read<SalesCommissionCubit>();
        final startDate =
            state is SalesCommissionSuccess ? state.startDate : cubit.startDate;
        final endDate =
            state is SalesCommissionSuccess ? state.endDate : cubit.endDate;

        List<SalesCommissionPoint> points = [];

        if (state is SalesCommissionSuccess &&
            state.data.chartPoints.isNotEmpty) {
          points = state.data.chartPoints;
        } else {
          // Visual fallback matching mockup
          points = [
            SalesCommissionPoint(label: 'SEP', sales: 300, commission: 30),
            SalesCommissionPoint(label: 'OCT', sales: 320, commission: 20),
            SalesCommissionPoint(label: 'NOV', sales: 450, commission: 45),
            SalesCommissionPoint(label: 'DEC', sales: 250, commission: 25),
            SalesCommissionPoint(label: 'JAN', sales: 380, commission: 38),
            SalesCommissionPoint(label: 'FEB', sales: 350, commission: 35),
          ];
        }

        // Compute dynamic sums from the points displayed in the chart
        final double totalSales = points.fold<double>(
          0.0,
          (sum, pt) => sum + pt.sales.toDouble(),
        );
        final double totalCommission = points.fold<double>(
          0.0,
          (sum, pt) => sum + pt.commission.toDouble(),
        );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.lightGreyColor.withValues(alpha: 0.5)),
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
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isNarrow = constraints.maxWidth < 620;

                  const titleWidget = Text(
                    'إحصائية عمولة الارباح ومبيعات من خدمات سان',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  );

                  final datePickersWidget = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StatisticsDatePickerField(
                        label: 'بحث من',
                        selectedDate: startDate,
                        onDateSelected: (date) {
                          cubit.fetchSalesCommission(fromDate: date);
                        },
                      ),
                      const SizedBox(width: 8),
                      StatisticsDatePickerField(
                        label: 'الي',
                        selectedDate: endDate,
                        onDateSelected: (date) {
                          cubit.fetchSalesCommission(toDate: date);
                        },
                      ),
                    ],
                  );

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleWidget,
                        const SizedBox(height: 10),
                        datePickersWidget,
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: titleWidget),
                      const SizedBox(width: 12),
                      datePickersWidget,
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  // KPI Badges on the side
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SalesKpiBadgeWidget(
                        amount: totalSales,
                        color: AppColors.chartOrange,
                      ),
                      const SizedBox(height: 12),
                      _SalesKpiBadgeWidget(
                        amount: totalCommission,
                        color: AppColors.chartTeal,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Spline Line Chart
                  Expanded(
                    child: SizedBox(
                      height: 190,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          header: '',
                          format: 'point.y SAR',
                        ),
                        primaryXAxis: const CategoryAxis(
                          majorGridLines: MajorGridLines(width: 0),
                          axisLine: AxisLine(width: 0),
                          labelStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                        primaryYAxis: const NumericAxis(
                          isVisible: false,
                        ),
                        series: <CartesianSeries>[
                          SplineSeries<SalesCommissionPoint, String>(
                            name: 'المبيعات',
                            dataSource: points,
                            xValueMapper: (SalesCommissionPoint pt, _) =>
                                ChartDateLocalizer.localize(pt.label, context),
                            yValueMapper: (SalesCommissionPoint pt, _) =>
                                pt.sales,
                            color: AppColors.chartOrange,
                            width: 3.5,
                            splineType: SplineType.natural,
                          ),
                          SplineSeries<SalesCommissionPoint, String>(
                            name: 'عمولة الأرباح',
                            dataSource: points,
                            xValueMapper: (SalesCommissionPoint pt, _) =>
                                ChartDateLocalizer.localize(pt.label, context),
                            yValueMapper: (SalesCommissionPoint pt, _) =>
                                pt.commission,
                            color: AppColors.chartTeal,
                            width: 3.5,
                            splineType: SplineType.natural,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SalesKpiBadgeWidget extends StatelessWidget {
  final double amount;
  final Color color;

  const _SalesKpiBadgeWidget({
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppImageKeys.coin,
          width: 18,
          height: 18,
          color: color,
          colorBlendMode: BlendMode.srcIn,
          errorBuilder: (_, __, ___) => Icon(
            Icons.monetization_on_rounded,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${amount.toStringAsFixed(2)} ر.س',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
