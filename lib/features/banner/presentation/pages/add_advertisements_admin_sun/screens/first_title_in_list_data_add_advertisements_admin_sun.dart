import 'package:flutter/cupertino.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';


class FirstTitleInListDataAddAdvertisementsAdminSun extends StatelessWidget {
  const FirstTitleInListDataAddAdvertisementsAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextInAppWidget(
          text:AppLanguageKeys.bannerImage,
          textSize: 16,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor:AppColors.blackColor,
        ),
        TextInAppWidget(
          text:AppLanguageKeys.bannerSizeNote,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor:AppColors.blackColor,
        )
      ],
    );
  }
}
