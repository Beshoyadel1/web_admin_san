import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class ContainerSold extends StatelessWidget {
  final String? text;
  final Color? backGroundColor;
  final void Function()? onTap;
  final double? horizontal, vertical;
  const ContainerSold(
      {super.key,
      this.onTap,
      this.text,
      this.backGroundColor,
      this.horizontal,
      this.vertical});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: horizontal ?? 15, vertical: vertical ?? 10),
        decoration: BoxDecoration(
          color: backGroundColor ?? AppColors.orangeColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: TextInAppWidget(
          text: text ?? LocaleKeys.carSold,
          textSize: 14,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
