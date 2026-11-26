import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      alignment: Alignment.center,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            AppColors.darkColor.withAlpha(190),
            BlendMode.darken,
          ),
          child: Image.asset(
            AppImageKeys.loginEmp,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImageKeys.sarWhiteLogo,
                height: 60, width: 60, fit: BoxFit.fill),
            const SizedBox(height: 8),
            const TextInAppWidget(
              text: LocaleKeys.introTextKey,
              textColor: AppColors.whiteColor,
              textSize: 22,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ],
    ));
  }
}
