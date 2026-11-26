import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/button_widget.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';

class LastTwoButtonInLogoutPage extends StatelessWidget {
  final void Function()? onTapConfirm, onTapCancel;

  const LastTwoButtonInLogoutPage({
    super.key,
    this.onTapConfirm,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonWidget(
          text: LocaleKeys.confirm,
          textColor: AppColors.whiteColor,
          buttonColor: AppColors.redColor,
          textSize: 12,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          heightContainer: 40,
          widthContainer: 120,
          borderRadius: 30,
          onTap: onTapConfirm,
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
          onTap: onTapCancel,
        )
      ],
    );
  }
}
