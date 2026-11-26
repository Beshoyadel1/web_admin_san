import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/statistics_providers/widgets/donut_chart_and_legend.dart';

import '../../../../../../../../core/helpers/themes/fonts.dart';

class ServicesStatistics extends StatelessWidget {
  final int providerId;
  const ServicesStatistics({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1280;
    return CustomContainer(
      containerWidth: isMobile ? double.infinity : 1000,
      isSelected: false,
      onTap: () {},
      typeWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextInAppWidget(
            text: LocaleKeys.internalServicesStatsKey,
            textSize: 16,
            fontWeightIndex: FontSelectionData.regularFontFamily,
          ),
          //SelectDateWidget(),
          const SizedBox(
            height: 30,
          ),
          DonutChartAndLegend(
            providerId: providerId,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
