import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import '../../../../../../core/pages_widgets/button_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';

class LastButtonInListDataAddAdvertisementsAdminSun extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final bool isLoading;

  const LastButtonInListDataAddAdvertisementsAdminSun({
    super.key,
    this.onTap,
    this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.whiteColor,
          ),
        )
            : TextInAppWidget(
          text: text ?? AppLanguageKeys.createBannerAd,
          textSize: 12,
          fontWeightIndex:
          FontSelectionData.regularFontFamily,
          textColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}