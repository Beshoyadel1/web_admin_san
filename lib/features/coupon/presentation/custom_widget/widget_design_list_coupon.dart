import 'package:flutter/material.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';

class WidgetDesignListCoupon
    extends StatelessWidget {
  const WidgetDesignListCoupon({
    super.key,
    this.couponId,
    this.couponCode,
    this.discountType,
    this.discountValue,
    this.isActive,
    this.maxDiscountValue,
    this.minValueToApply,
    this.startDate,
    this.endDate,
    this.providers,
    this.onTapDetails,
  });

  final int? couponId;
  final String? couponCode;

  final int? discountType;
  final double? discountValue;

  final bool? isActive;

  final double? maxDiscountValue;
  final double? minValueToApply;

  final DateTime? startDate;
  final DateTime? endDate;

  final List<int>? providers;

  final VoidCallback? onTapDetails;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius:
      BorderRadius.circular(12),

      typeWidget: Wrap(
        spacing: 25,
        runSpacing: 15,

        crossAxisAlignment:
        WrapCrossAlignment.center,

        alignment:
        WrapAlignment.spaceBetween,

        children: [
          // =========================================
          // ID
          // =========================================

          SizedBox(
            width: 80,
            child: TitleWithSubTitle(
              title:
              AppLanguageKeys.identity,

              subTitle:
              couponId?.toString() ?? '---',

              textSizeTitle: 12,

              titleColor:
              AppColors.greyColor,

              textSizeSubTitle: 14,

              subTitleColor:
              AppColors.darkColor,
            ),
          ),

          // =========================================
          // CODE
          // =========================================

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title:
              AppLanguageKeys.couponCode,
              subTitle:
              couponCode ?? '---',

              textSizeTitle: 12,

              titleColor:
              AppColors.greyColor,

              textSizeSubTitle: 14,

              subTitleColor:
              AppColors.darkColor,
            ),
          ),

          // =========================================
          // DISCOUNT
          // =========================================

          SizedBox(
            width: 120,
            child: TitleWithSubTitle(
              title:
              AppLanguageKeys.discountValue,

              subTitle:
              discountValue?.toString() ??
                  '0',

              textSizeTitle: 12,

              titleColor:
              AppColors.greyColor,

              textSizeSubTitle: 14,

              subTitleColor:
              AppColors.darkColor,
            ),
          ),

          // =========================================
          // MAX DISCOUNT
          // =========================================

          SizedBox(
            width: 140,
            child: TitleWithSubTitle(
              title:
              AppLanguageKeys.maxDiscountValue,

              subTitle:
              maxDiscountValue
                  ?.toString() ??
                  '0',

              textSizeTitle: 12,

              titleColor:
              AppColors.greyColor,

              textSizeSubTitle: 14,

              subTitleColor:
              AppColors.darkColor,
            ),
          ),

          // =========================================
          // MIN VALUE
          // =========================================

          SizedBox(
            width: 140,
            child: TitleWithSubTitle(
              title:
              AppLanguageKeys.minValueToApply,

              subTitle:
              minValueToApply
                  ?.toString() ??
                  '0',

              textSizeTitle: 12,

              titleColor:
              AppColors.greyColor,

              textSizeSubTitle: 14,

              subTitleColor:
              AppColors.darkColor,
            ),
          ),

          // =========================================
          // PROVIDERS
          // =========================================

          SizedBox(
            width: 130,
            child: TitleWithSubTitle(
              title:
              AppLanguageKeys.serviceProviders,

              subTitle:
              providers == null ||
                  providers!.isEmpty
                  ? '---'
                  : providers!
                  .join(', '),

              textSizeTitle: 12,

              titleColor:
              AppColors.greyColor,

              textSizeSubTitle: 14,

              subTitleColor:
              AppColors.darkColor,
            ),
          ),

          // =========================================
          // STATUS
          // =========================================

          SizedBox(
            width: 90,
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: isActive == true
                    ? AppColors.greenColor
                    .withOpacity(0.1)
                    : Colors.red
                    .withOpacity(0.1),

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: TextInAppWidget(
                text: isActive == true
                    ? AppLanguageKeys.active
                    : AppLanguageKeys.inactive,

                textSize: 12,

                fontWeightIndex:
                FontSelectionData
                    .mediumFontFamily,

                textColor:
                isActive == true
                    ? AppColors.greenColor
                    : Colors.red,

                isTextCenter: true,
              ),
            ),
          ),

          // =========================================
          // DETAILS
          // =========================================

          SizedBox(
            width: 110,

            child: InkWell(
              onTap: onTapDetails,

              child: Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),

                decoration:
                BoxDecoration(
                  color:
                  AppColors.whiteColor,

                  borderRadius:
                  BorderRadius.circular(20),

                  border: Border.all(
                    color:
                    AppColors.orangeColor,
                  ),
                ),

                child: const Center(
                  child: TextInAppWidget(
                    text:
                    AppLanguageKeys.details,

                    textSize: 12,

                    fontWeightIndex:
                    FontSelectionData
                        .mediumFontFamily,

                    textColor:
                    AppColors.orangeColor,
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