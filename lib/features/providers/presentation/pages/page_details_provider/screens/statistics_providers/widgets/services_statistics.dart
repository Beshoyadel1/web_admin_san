import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/widgets/donut_chart_and_legend.dart';
import '../../../../../../../../core/theming/fonts.dart';

class ServicesStatistics extends StatelessWidget {
  const ServicesStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1280;
    return CustomContainer(
      containerWidth:isMobile?double.infinity: 1000,
      isSelected: false,
      onTap: () {},
      typeWidget: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInAppWidget(
            text: AppLanguageKeys.internalServicesStatsKey,
            textSize: 16,
            fontWeightIndex: FontSelectionData.regularFontFamily,
          ),
          //SelectDateWidget(),
          SizedBox(
            height: 30,
          ),
          DonutChartAndLegend(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
