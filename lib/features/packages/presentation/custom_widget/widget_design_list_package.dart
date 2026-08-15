import 'package:flutter/material.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';

class WidgetDesignListPackage extends StatelessWidget {
  const WidgetDesignListPackage({
    super.key,
    this.packageId,
    this.packageName,
    this.packageLatinName,
    this.monthlyPrice,
    this.annualPrice,
    this.description,
    this.latinDescription,
    this.onTapDetails,
    this.nameButton,
    this.spacing,
  });

  final String? packageId;
  final String? packageName;
  final String? packageLatinName;

  final double? monthlyPrice;
  final double? annualPrice;

  final String? description;
  final String? latinDescription;

  final void Function()? onTapDetails;

  final String? nameButton;
  final double? spacing;

  @override
  Widget build(BuildContext context) {

    final bool isArabic =
        Localizations.localeOf(context).languageCode == 'ar';


    final String packageDisplayName = isArabic
        ? (packageName ?? '---')
        : (packageLatinName ?? '---');


    final String packageDisplayDescription = isArabic
        ? (description ?? '---')
        : (latinDescription ?? '---');

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: spacing ?? 20,
        runSpacing: 15,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.identity,
              subTitle: packageId ?? '#1',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),


          SizedBox(
            width: 200,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.packageName,
              subTitle: packageDisplayName,
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================
          // MONTHLY PRICE
          // =========================

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.monthlyPrice,
              subTitle: '${monthlyPrice ?? 0}',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================
          // ANNUAL PRICE
          // =========================

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.annualPrice,
              subTitle: '${annualPrice ?? 0}',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================
          // DESCRIPTION
          // =========================

          // SizedBox(
          //   width: 250,
          //   child: TitleWithSubTitle(
          //     title: AppLanguageKeys.description,
          //     subTitle: packageDisplayDescription,
          //     textSizeTitle: 12,
          //     titleColor: AppColors.greyColor,
          //     textSizeSubTitle: 14,
          //     subTitleColor: AppColors.darkColor,
          //   ),
          // ),

          // =========================
          // DETAILS BUTTON
          // =========================

          SizedBox(
            width: 110,
            child: InkWell(
              onTap: onTapDetails,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: AppColors.orangeColor,
                  ),
                ),
                child: Center(
                  child: TextInAppWidget(
                    text: nameButton ?? AppLanguageKeys.details,
                    textSize: 12,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}