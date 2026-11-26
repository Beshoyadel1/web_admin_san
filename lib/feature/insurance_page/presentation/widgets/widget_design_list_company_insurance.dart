import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/custom_container.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

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
      this.insuranceMethods});

  final String? companyId,
      name,
      nameButton,
      paymentMethods,
      paymentDuration,
      insuranceType,
      insuranceMethods;
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
          //     title: LocaleKeys.identity,
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
                        backgroundImage: MemoryImage(image!),
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
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
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
              title: LocaleKeys.paymentMethods,
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
              title: LocaleKeys.paymentDuration,
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
              title: LocaleKeys.insuranceType,
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
              title: LocaleKeys.insuranceMethods,
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
