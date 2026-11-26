import 'package:flutter/material.dart';
import '../../car_haraj_orders_page/screens/bar_chart_data_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      typeWidget: const Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextInAppWidget(
            text: LocaleKeys.carMarketSales,
            textSize: 16,
            fontWeightIndex: FontSelectionData.regularFontFamily,
          ),
          //  TextInAppWidget(
          //   text: LocaleKeys.priceKey,
          //   textSize: 16,
          //   fontWeightIndex: FontSelectionData.regularFontFamily,
          //   textColor: AppColors.orangeColor,
          // ),
          BarChartDataWidget()
        ],
      ),
    );
  }
}
