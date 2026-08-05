import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/text_form_field_widget.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class DesignBillOrder extends StatelessWidget {
  const DesignBillOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {},
      isSelected: true,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.orangeColor.withOpacity(0.4)),
      typeWidget:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
           const TextInAppWidget(
            text:AppLanguageKeys.invoice,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               TextInAppWidget(
                text:AppLanguageKeys.servicePrice,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.greyColor,
              ),
              Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInAppWidget(
                    text: "1450",
                    textSize: 16,
                    fontWeightIndex:
                    FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                   TextInAppWidget(
                    text: AppLanguageKeys.dirham,
                    textSize: 16,
                    fontWeightIndex:
                    FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                ],
              ),
            ],
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInAppWidget(
                text:AppLanguageKeys.valueAddedTax,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.greyColor,
              ),
              TextInAppWidget(
                text: "1450",
                textSize: 16,
                fontWeightIndex:
                FontSelectionData.regularFontFamily,
                textColor: AppColors.blackColor,
              ),
            ],
          ),
          Divider(
            color: AppColors.greyColor.withOpacity(0.5),
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInAppWidget(
                text:AppLanguageKeys.total,
                textSize: 15,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.blackColor,
              ),
              Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextInAppWidget(
                    text: "1450",
                    textSize: 16,
                    fontWeightIndex:
                    FontSelectionData.regularFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                  TextInAppWidget(
                    text: AppLanguageKeys.dirham,
                    textSize: 16,
                    fontWeightIndex:
                    FontSelectionData.regularFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: AppColors.greyColor.withOpacity(0.5),
          ),

        ],
      ),
    );
  }
}
