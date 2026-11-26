import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders
    extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final Color? backGroundColor;
  const ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders({
    super.key,
    this.onTap,
    this.text,
    this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 8),
        decoration: BoxDecoration(
          color: backGroundColor ?? AppColors.orangeColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextInAppWidget(
          text: text ?? LocaleKeys.viewAll,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
