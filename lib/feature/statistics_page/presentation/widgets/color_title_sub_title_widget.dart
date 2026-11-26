import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class ColorTitleSubTitleWidget extends StatelessWidget {
  final Color? backgroundColor;
  final String? title, subTitle;
  const ColorTitleSubTitleWidget(
      {super.key, this.backgroundColor, this.subTitle, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: backgroundColor ?? AppColors.blueAccentColor,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            TextInAppWidget(
              text: title ?? LocaleKeys.userCars.tr(),
              textSize: 15,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.blackColor,
            ),
            TextInAppWidget(
              text: subTitle ?? '',
              textSize: 12,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.greyColor,
            ),
          ],
        ))
      ],
    );
  }
}
