import 'package:flutter/material.dart';

import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';

class CircularProgressIndicatorWithTextWidget extends StatelessWidget {
  final String text;
  final double? textSize;

  const CircularProgressIndicatorWithTextWidget(
      {super.key, required this.text, this.textSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        CircularProgressIndicator(
          color: AppColors.orangeColor,
        ),
        TextInAppWidget(
          text: text,
          textSize: textSize ?? 12,
          textColor: AppColors.blackColor44,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
        )
      ],
    );
  }
}
