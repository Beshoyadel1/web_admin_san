import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_general_statistics_model/get_company_general_statistics_model.dart';

class FourPartDoughnut extends StatelessWidget {
  final List<ServiceChart> services;
  const FourPartDoughnut({
    super.key,
    required this.services,
  });

  List<ServiceChart> get _sortedServices {
    final sorted = List<ServiceChart>.from(services);

    sorted.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return sorted;
  }

  List<ChartData> get _chartData {
    if (services.isEmpty) {
      return [
        ChartData('', 1, AppColors.lightGreyColor),
      ];
    }

    return _sortedServices.asMap().entries.map((entry) {
      final index = entry.key;
      final service = entry.value;

      final title = service.serviceName;

      return ChartData(
        title,
        service.value.toDouble(),
        legendColor(index),
      );
    }).toList();
  }

  int get _totalOrders {
    return services.fold<int>(
      0,
      (sum, s) => sum + s.value.toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        annotations: [
          CircularChartAnnotation(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInAppWidget(
                  text: _totalOrders.toString(),
                  textSize: 15,
                  textColor: AppColors.blackColor,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                ),
                const TextInAppWidget(
                  text: LocaleKeys.ordersKey,
                  textSize: 12,
                  textColor: AppColors.blackColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                ),
              ],
            ),
          )
        ],
        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
            dataSource: _chartData,
            xValueMapper: (d, _) => d.x,
            yValueMapper: (d, _) => d.y,
            pointColorMapper: (d, _) => d.color,
            innerRadius: '70%',
            strokeColor: AppColors.whiteColor,
            strokeWidth: 2,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final Color color;
}
