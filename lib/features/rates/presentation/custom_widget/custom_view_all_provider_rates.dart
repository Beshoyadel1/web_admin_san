import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/text_styles.dart';

class CustomViewAllProviderRates extends StatelessWidget {
  const CustomViewAllProviderRates(
      {super.key,
        this.id,
        this.spacing,
        this.nameProvider,
        this.avgRate,
        this.countRate,
        this.onTapViewRates,
        this.nameButton
      });

  final String? id,nameProvider,countRate,avgRate,nameButton;
  final double? spacing;
  final void Function()? onTapViewRates;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: spacing ?? 20,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          TitleWithSubTitle(
            title: AppLanguageKeys.identity,
            subTitle: id ?? "#1",
            textSizeTitle:12,
            titleColor: AppColors.greyColor,
            textSizeSubTitle: 14,
            subTitleColor: AppColors.darkColor,
          ),
          TitleWithSubTitle(
            title: AppLanguageKeys.nameProvider,
            subTitle: nameProvider ?? "tester",
            textSizeTitle:12,
            titleColor: AppColors.greyColor,
            textSizeSubTitle: 14,
            subTitleColor: AppColors.darkColor,
          ),
          TitleWithSubTitle(
            title: AppLanguageKeys.totalReviews,
            subTitle: countRate ?? "200",
            textSizeTitle:12,
            titleColor: AppColors.greyColor,
            textSizeSubTitle: 14,
            subTitleColor: AppColors.darkColor,
          ),
          Wrap(
            spacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(AppImageKeys.star11,width: 20,),
              TextInAppWidget(
                text: avgRate??"5.0",
                textSize: 15,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.blackColor,
              ),
            ],
          ),
          InkWell(
            onTap:onTapViewRates,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                      color: AppColors.orangeColor
                  )
              ),
              child: TextInAppWidget(
                text: nameButton??AppLanguageKeys.viewReviews,
                textSize: 12,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.orangeColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}