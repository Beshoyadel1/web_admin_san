import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';

import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/text_styles.dart';

class WidgetDesignListCompanyInsurance extends StatelessWidget {
  const WidgetDesignListCompanyInsurance(
      {super.key,
        this.companyId,
        this.spacing,
        this.name,
        this.onTabDetails,
        this.nameButton,
        this.image,
        this.paymentMethods,
        this.paymentDuration,
        this.insuranceType,
        this.insuranceMethods
      });

  final String? companyId,name,nameButton,paymentMethods,paymentDuration,insuranceType,insuranceMethods;
  final double? spacing;
  final void Function()? onTabDetails;
  final Uint8List? image;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: onTabDetails,
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: spacing ?? 20,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [

          // SizedBox(
          //   width: 120,
          //   child: TitleWithSubTitle(
          //     title: AppLanguageKeys.identity,
          //     subTitle: companyId ?? "#1",
          //     textSizeTitle: 12,
          //     titleColor: AppColors.greyColor,
          //     textSizeSubTitle: 14,
          //     subTitleColor: AppColors.darkColor,
          //   ),
          // ),

          SizedBox(
            width: 235,
            child: Wrap(
              spacing: 15,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 5,
              children: [
                image != null
                    ? CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  MemoryImage(image!),
                )
                    : const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                ),

                SizedBox(
                  width: 180,
                  child: TextInAppWidget(
                    text: name ?? "###",
                    textSize: 15,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
                    textColor: AppColors.blackColor,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.paymentMethods,
              subTitle: paymentMethods ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.paymentDuration,
              subTitle: paymentDuration ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),
          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.insuranceType,
              subTitle: insuranceType ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),
          SizedBox(
            width: 180,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.insuranceMethods,
              subTitle: insuranceMethods ?? "---",
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.orangeColor,
            ),
          ),

        ],
      ),
    );
  }
}