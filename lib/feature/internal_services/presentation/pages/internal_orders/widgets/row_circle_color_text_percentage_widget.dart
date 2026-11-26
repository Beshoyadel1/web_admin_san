import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/container_percentage.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/small_circle.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class RowCircleColorTextPercentageWidget extends StatelessWidget {
  final Color colorCircle;
  final String text, percentage;

  const RowCircleColorTextPercentageWidget({
    super.key,
    required this.colorCircle,
    required this.text,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Flexible(
          child: Row(
            spacing: 5,
            children: [
              SmallCircle(
                color: colorCircle,
              ),
              Expanded(
                child: TextInAppWidget(
                  text: text,
                  textSize: 11,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textColor: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
        ContainerPercentage(percentage: percentage)
      ],
    );
  }
}
