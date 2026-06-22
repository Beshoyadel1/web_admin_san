import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class WidgetDesignCarUser extends StatelessWidget {
  final String? name, plateNo;
  final bool? isDefault;
  final Uint8List? imageCar;

  const WidgetDesignCarUser(
      {super.key,
      this.isDefault = true,
      this.name,
      this.plateNo,
      this.imageCar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
            color: isDefault! ? AppColors.orangeColor : AppColors.greyColor),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              imageCar != null
                  ? Image.memory(
                      imageCar!,
                      width: 40,
                      height: 40,
                    )
                  : Image.asset(
                      AppImageKeys.car501,
                      width: 40,
                      height: 40,
                    ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInAppWidget(
                    text: name ?? 'My Camry',
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                  TextInAppWidget(
                    text: plateNo ?? 'ABD-1234',
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: isDefault!
                        ? AppColors.orangeColor
                        : AppColors.greyColor,
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
                color: isDefault!
                    ? AppColors.CircleLightorangeColor
                    : AppColors.greyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isDefault!
                        ? AppColors.orangeColor
                        : AppColors.darkColor)),
            child: TextInAppWidget(
              text: isDefault!
                  ? AppLanguageKeys.useAsPrimaryAccount
                  : AppLanguageKeys.replaceCarAccount,
              textSize: 12,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor:
                  isDefault! ? AppColors.orangeColor : AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
