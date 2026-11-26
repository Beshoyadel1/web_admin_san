import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

import 'button_widget.dart';
import '../helpers/colors/app_colors.dart';
import '../helpers/themes/fonts.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 20, top: 20),
          child: ButtonWidget(
            text: LocaleKeys.Back_Button,
            fontWeightIndex: FontSelectionData.semiBoldFontFamily,
            onTap: () {
              Navigator.pop(context);
            },
            textColor: AppColors.darkColor,
            buttonColor: AppColors.transparent,
            textSize: 15,
          ),
        ),
      ],
    );
  }
}
