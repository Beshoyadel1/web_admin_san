import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../core/widgets/button_widget.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../core/helpers/themes/fonts.dart';

class LastTwoButtonNotificationDialog extends StatelessWidget {
  final VoidCallback? onTapView;
  final VoidCallback? onTapClose;

  const LastTwoButtonNotificationDialog({
    super.key,
    this.onTapView,
    this.onTapClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonWidget(
          text: LocaleKeys.viewAll,
          textColor: AppColors.whiteColor,
          buttonColor: AppColors.redColor,
          textSize: 12,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          heightContainer: 40,
          widthContainer: 120,
          borderRadius: 30,
          onTap: onTapView,
        ),
        ButtonWidget(
          text: LocaleKeys.cancel,
          textColor: AppColors.whiteColor,
          buttonColor: AppColors.blackColor44,
          textSize: 12,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          heightContainer: 40,
          widthContainer: 120,
          borderRadius: 30,
          onTap: onTapClose,
        ),
      ],
    );
  }
}
