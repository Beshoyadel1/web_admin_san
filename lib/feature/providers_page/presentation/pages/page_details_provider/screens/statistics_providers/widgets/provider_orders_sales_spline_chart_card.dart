import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/utils/chart_date_localizer.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/statistics_providers_cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_state.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_orders_sales_model/get_provider_orders_sales_model.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/statistics_date_picker_field.dart';

class ProviderOrdersSalesSplineChartCard extends StatefulWidget {
  final int providerId;

  const ProviderOrdersSalesSplineChartCard({
    super.key,
    required this.providerId,
  });

  @override
  State<ProviderOrdersSalesSplineChartCard> createState() =>
      _ProviderOrdersSalesSplineChartCardState();
}

class _ProviderOrdersSalesSplineChartCardState
    extends State<ProviderOrdersSalesSplineChartCard> {
  DateTime? _fromDate;
  DateTime? _toDate;

  void _onFromDateSelected(DateTime date) {
    setState(() {
      _fromDate = date;
    });
    _fetchData();
  }

  void _onToDateSelected(DateTime date) {
    setState(() {
      _toDate = date;
    });
    _fetchData();
  }

  void _fetchData() {
    context.read<GetProviderOrdersSalesCubit>().getProviderOrdersSales(
          providerId: widget.providerId,
          startDate: _fromDate,
          endDate: _toDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Date Pickers
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 360;
              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.orders.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: StatisticsDatePickerField(
                            label: LocaleKeys.searchFrom.tr(),
                            selectedDate: _fromDate,
                            onDateSelected: _onFromDateSelected,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StatisticsDatePickerField(
                            label: LocaleKeys.toKey.tr(),
                            selectedDate: _toDate,
                            onDateSelected: _onToDateSelected,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.orders.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StatisticsDatePickerField(
                        label: LocaleKeys.searchFrom.tr(),
                        selectedDate: _fromDate,
                        onDateSelected: _onFromDateSelected,
                      ),
                      const SizedBox(width: 8),
                      StatisticsDatePickerField(
                        label: LocaleKeys.toKey.tr(),
                        selectedDate: _toDate,
                        onDateSelected: _onToDateSelected,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Chart Body
          BlocBuilder<GetProviderOrdersSalesCubit, GetProviderOrdersSalesState>(
            builder: (context, state) {
              if (state is GetProviderOrdersSalesLoading) {
                return const SizedBox(
                  height: 310,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.orangeColor,
                    ),
                  ),
                );
              }

              if (state is GetProviderOrdersSalesError) {
                return SizedBox(
                  height: 310,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(
                            color: AppColors.darkGreyColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: _fetchData,
                            child: Text(
                              LocaleKeys.retry.tr(),
                              style: const TextStyle(
                                color: AppColors.orangeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              List<DataPoint> dataPoints = [];
              if (state is GetProviderOrdersSalesSuccess) {
                dataPoints = state.data.dataPoints;
              }

              if (dataPoints.isEmpty) {
                return SizedBox(
                  height: 310,
                  child: Center(
                    child: Text(
                      LocaleKeys.noOrdersInPeriod.tr(),
                      style: const TextStyle(
                        color: AppColors.darkGreyColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 310,
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: '',
                    format: 'point.x\npoint.y ${LocaleKeys.sarCurrency.tr()}',
                    textStyle: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    color: AppColors.darkColor,
                  ),
                  primaryXAxis: const CategoryAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(
                      color: AppColors.cardStroke,
                      width: 1,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  primaryYAxis: const NumericAxis(
                    axisLine: AxisLine(width: 0),
                    majorGridLines: MajorGridLines(
                      width: 1,
                      color: AppColors.cardStroke,
                      dashArray: <double>[5, 5],
                    ),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  series: <CartesianSeries>[
                    SplineAreaSeries<DataPoint, String>(
                      name: LocaleKeys.orders.tr(),
                      dataSource: dataPoints,
                      xValueMapper: (DataPoint pt, _) =>
                          ChartDateLocalizer.localize(pt.label, context),
                      yValueMapper: (DataPoint pt, _) => pt.value,
                      borderColor: AppColors.chartTeal,
                      borderWidth: 2.5,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.chartTeal.withValues(alpha: 0.35),
                          AppColors.chartTeal.withValues(alpha: 0.05),
                        ],
                      ),
                      splineType: SplineType.natural,
                      markerSettings: const MarkerSettings(
                        isVisible: false,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
