import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class FirstPartInLogoutPage extends StatelessWidget {
  const FirstPartInLogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        const TextInAppWidget(
          text: LocaleKeys.logout_dashboard,
          textSize: 20,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),
        const TextInAppWidget(
          text: LocaleKeys.confirmLogout,
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
