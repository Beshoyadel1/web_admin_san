import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../helpers/colors/app_colors.dart';
import 'button_widget.dart';

class ChangeLanguageButton extends StatelessWidget {
  const ChangeLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      iconData: Icons.language,
      iconColor: AppColors.darkColor,
      buttonColor: AppColors.transparent,
      iconSize: 25,
      borderRadius: 7,
      onTap: () {
        final isArabic = context.locale.languageCode == 'ar';
        context.setLocale(
          isArabic ? const Locale('en') : const Locale('ar'),
        );
      },
    );
  }
}
