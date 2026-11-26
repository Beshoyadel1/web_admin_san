import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

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
            text: LocaleKeys.totalReviews,
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
