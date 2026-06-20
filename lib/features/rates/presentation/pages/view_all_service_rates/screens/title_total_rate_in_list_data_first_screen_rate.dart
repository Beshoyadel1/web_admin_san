import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class TitleTotalRateInListDataFirstScreenRate extends StatelessWidget {
  final String averageRate;

  const TitleTotalRateInListDataFirstScreenRate({
    super.key,
    required this.averageRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: TextInAppWidget(
            text: AppLanguageKeys.totalReviews,
            textSize: 16,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.blackColor,
          ),
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Image.asset(AppImageKeys.star11),
            const SizedBox(width: 5),
            TextInAppWidget(
              text: averageRate,
              textSize: 22,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.blackColor,
            ),
          ],
        )
      ],
    );
  }
}