import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class FirstPartInLogoutDashboard extends StatelessWidget {
  const FirstPartInLogoutDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.logout,
          textSize: 20,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),
        const TextInAppWidget(
          text: AppLanguageKeys.confirmLogout,
          textSize: 12,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),
        Image.asset(
          AppImageKeys.logout,
          width: 100,
        )
      ],
    );
  }
}
