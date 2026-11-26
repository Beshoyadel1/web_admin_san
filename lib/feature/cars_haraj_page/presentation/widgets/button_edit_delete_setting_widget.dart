import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';
import '../../../../../core/helpers/colors/app_colors.dart';

class ButtonEditDeleteSettingWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool isDelete;

  const ButtonEditDeleteSettingWidget(
      {super.key, this.onTap, this.isDelete = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 60),
        decoration: BoxDecoration(
          color: isDelete ? AppColors.redColor : AppColors.blackColor44,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        ),
        child: Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            Icon(
              isDelete ? CupertinoIcons.delete : Icons.edit,
              color: AppColors.whiteColor,
              size: 15,
            ),
            TextInAppWidget(
              text: isDelete ? LocaleKeys.delete : LocaleKeys.edit,
              textSize: 16,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
