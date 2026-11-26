import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/button_widget.dart';

class LoginLanguageButtonWidget extends StatelessWidget {
  const LoginLanguageButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 45,
      child: ButtonWidget(
        text: LocaleKeys.Language,
        textSize: 17,
        textColor: AppColors.orangeColor,
        fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        borderRadius: 25,
        onTap: () {
          final isArabic = context.locale.languageCode == 'ar';
          context.setLocale(
            isArabic ? const Locale('en') : const Locale('ar'),
          );
        },
      ),
    );
  }
}
