import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class ContainerDetailsOfTheProcess extends StatelessWidget {
  final String? title;
  final int status;
  final Color? backGroundColor, textColor, borderColor;
  final IconData? icon;
  final void Function()? onTap;
  const ContainerDetailsOfTheProcess(
      {super.key,
      required this.status,
      this.title,
      this.textColor,
      this.borderColor,
      this.backGroundColor,
      this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: (backGroundColor ?? AppColors.orangeColor),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: (borderColor ?? AppColors.orangeColor),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Wrap(
          spacing: 10,
          // mainAxisAlignment: MainAxisAlignment.center,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              icon ?? Icons.file_copy,
              color: AppColors.whiteColor,
              size: 12,
            ),
            TextInAppWidget(
              text: title ?? LocaleKeys.transactionDetails,
              textSize: 14,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: (textColor ?? AppColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
