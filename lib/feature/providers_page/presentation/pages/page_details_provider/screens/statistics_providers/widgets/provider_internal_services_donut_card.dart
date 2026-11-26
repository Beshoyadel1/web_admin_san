import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_service_statistics_model/provider_service_chart_item.dart';
import 'package:web_admin_san/feature/statistics_page/data/model/get_provider_service_statistics_model/summary_card.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/widgets/statistics_date_picker_field.dart';

class DonutSegmentItem {
  final String label;
  final double value;
  final double percentage;
  final Color color;

  const DonutSegmentItem({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });
}

class ProviderInternalServicesDonutCard extends StatefulWidget {
  final List<SummaryCard> summaryCards;
  final List<ProviderServiceChartItem> chart;
  final Function(DateTime? from, DateTime? to)? onDateFilter;

  const ProviderInternalServicesDonutCard({
    super.key,
    required this.summaryCards,
    this.chart = const [],
    this.onDateFilter,
  });

  @override
  State<ProviderInternalServicesDonutCard> createState() =>
      _ProviderInternalServicesDonutCardState();
}

class _ProviderInternalServicesDonutCardState
    extends State<ProviderInternalServicesDonutCard> {
  DateTime? _fromDate;
  DateTime? _toDate;

  void _onFromDateSelected(DateTime date) {
    setState(() {
      _fromDate = date;
    });
    widget.onDateFilter?.call(_fromDate, _toDate);
  }

  void _onToDateSelected(DateTime date) {
    setState(() {
      _toDate = date;
    });
    widget.onDateFilter?.call(_fromDate, _toDate);
  }

  Color _getColorForService(String name, int index) {
    final lower = name.toLowerCase();
    if (lower.contains('صيان') || lower.contains('repair')) {
      return AppColors.orangeColor;
    } else if (lower.contains('نقل') ||
        lower.contains('متنقل') ||
        lower.contains('transport')) {
      return AppColors.seaBlueColor;
    } else if (lower.contains('غيار') || lower.contains('spare')) {
      return AppColors.darkGreyColor;
    } else if (lower.contains('باق') || lower.contains('package')) {
      return AppColors.chartTeal;
    } else if (lower.contains('بترول') ||
        lower.contains('petrol') ||
        lower.contains('زيت') ||
        lower.contains('oil')) {
      return AppColors.darkorangeColor;
    }

    final colors = [
      AppColors.orangeColor,
      AppColors.seaBlueColor,
      AppColors.darkGreyColor,
      AppColors.chartTeal,
      AppColors.darkorangeColor,
    ];
    return colors[index % colors.length];
  }

  List<DonutSegmentItem> _buildSegments() {
    // 1. If backend returned Chart percentages
    if (widget.chart.isNotEmpty) {
      return List.generate(widget.chart.length, (i) {
        final item = widget.chart[i];
        final label =
            item.serviceName ?? '${LocaleKeys.serviceDefault.tr()} ${i + 1}';
        return DonutSegmentItem(
          label: label,
          value: item.percentage > 0 ? item.percentage : 0.01,
          percentage: item.percentage,
          color: _getColorForService(label, i),
        );
      });
    }

    // 2. Otherwise compute dynamically from summary cards with completed orders
    double total = 0;
    for (final card in widget.summaryCards) {
      total += (card.orderCount ?? 0).toDouble();
    }

    if (total == 0) {
      if (widget.summaryCards.isEmpty) {
        return [
          DonutSegmentItem(
            label: LocaleKeys.noCompletedOrders.tr(),
            value: 1,
            percentage: 0,
            color: AppColors.veryLightGreyColor,
          ),
        ];
      }

      return List.generate(widget.summaryCards.length, (i) {
        final card = widget.summaryCards[i];
        final label =
            card.serviceName ?? '${LocaleKeys.serviceDefault.tr()} ${i + 1}';
        return DonutSegmentItem(
          label: label,
          value: 1,
          percentage: 0,
          color: _getColorForService(label, i),
        );
      });
    }

    final List<DonutSegmentItem> segments = [];
    for (int i = 0; i < widget.summaryCards.length; i++) {
      final card = widget.summaryCards[i];
      final val = (card.orderCount ?? 0).toDouble();
      final pct = (val / total) * 100;
      final label =
          card.serviceName ?? '${LocaleKeys.serviceDefault.tr()} ${i + 1}';
      segments.add(
        DonutSegmentItem(
          label: label,
          value: val > 0 ? val : 0.01,
          percentage: pct,
          color: _getColorForService(label, i),
        ),
      );
    }
    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final segments = _buildSegments();
    final bool hasData = segments.any((s) => s.value > 0);

    return Container(
      height: 380,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header & Date Pickers
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 430;
              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.mainServicesStatistics.tr(),
                      style: const TextStyle(
                        fontSize: 14,
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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        LocaleKeys.mainServicesStatistics.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColor,
                        ),
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

          const SizedBox(height: 8),

          // Donut Chart & Legends
          Expanded(
            child: Row(
              children: [
                // Legends List
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: segments.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: item.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${item.percentage.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: item.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(width: 8),

                // Donut Chart
                Expanded(
                  flex: 5,
                  child: SfCircularChart(
                    margin: EdgeInsets.zero,
                    series: <CircularSeries>[
                      DoughnutSeries<DonutSegmentItem, String>(
                        dataSource: hasData
                            ? segments
                            : [
                                DonutSegmentItem(
                                  label: LocaleKeys.empty.tr(),
                                  value: 1,
                                  percentage: 0,
                                  color: AppColors.veryLightGreyColor,
                                ),
                              ],
                        xValueMapper: (DonutSegmentItem data, _) => data.label,
                        yValueMapper: (DonutSegmentItem data, _) => data.value,
                        pointColorMapper: (DonutSegmentItem data, _) =>
                            data.color,
                        innerRadius: '65%',
                        radius: '90%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
