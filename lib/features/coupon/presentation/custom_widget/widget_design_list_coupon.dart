import 'package:flutter/material.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/custom_widget/title_with_sub_title.dart';
import 'coupon_status_widget.dart';

class WidgetDesignListCoupon extends StatelessWidget {
  const WidgetDesignListCoupon({
    super.key,
    this.couponId,
    this.couponCode,
    this.discountValue,
    this.startDate,
    this.endDate,
    this.isActive,
    this.onTapDetails,
    this.onTapEdit,
    this.onTapDelete,
  });

  final int? couponId;
  final String? couponCode;
  final double? discountValue;

  final DateTime? startDate;
  final DateTime? endDate;

  final bool? isActive;

  final VoidCallback? onTapDetails;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;

  bool get isExpired {
    if (endDate == null) return false;

    return DateTime.now().isAfter(endDate!);
  }

  // bool get canOpenDetails {
  //   return isActive == true && !isExpired;
  // }

  String _formatDate(DateTime? date) {
    if (date == null) return '---';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      containerWidth: double.infinity,
      borderRadius: BorderRadius.circular(12),
      typeWidget: Wrap(
        spacing: 25,
        runSpacing: 15,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // =========================================
          // ID
          // =========================================

          SizedBox(
            width: 80,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.identity,
              subTitle: couponId?.toString() ?? '---',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================================
          // CODE
          // =========================================

          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.couponCode,
              subTitle: couponCode ?? '---',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================================
          // DISCOUNT
          // =========================================

          // SizedBox(
          //   width: 120,
          //   child: TitleWithSubTitle(
          //     title: AppLanguageKeys.discountValue,
          //     subTitle: discountValue?.toString() ?? '0',
          //     textSizeTitle: 12,
          //     titleColor: AppColors.greyColor,
          //     textSizeSubTitle: 14,
          //     subTitleColor: AppColors.darkColor,
          //   ),
          // ),

          // =========================================
          // START DATE
          // =========================================

          SizedBox(
            width: 130,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.startDate,
              subTitle: _formatDate(startDate),
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================================
          // END DATE
          // =========================================

          SizedBox(
            width: 130,
            child: TitleWithSubTitle(
              title: AppLanguageKeys.endDate,
              subTitle: _formatDate(endDate),
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // =========================================
// STATUS
// =========================================

          SizedBox(
            width: 100,
            child: CouponStatusWidget(
              isActive: isActive,
              endDate: endDate,
            ),
          ),

// =========================================
// DETAILS
// =========================================

          _detailsButton(
            onTap: onTapDetails,
          ),

// =========================================
// EDIT
// =========================================

          _actionButton(
            text: AppLanguageKeys.edit,
            icon: Icons.edit_outlined,
            color: AppColors.orangeColor,
            onTap: onTapEdit,
          ),

// =========================================
// DELETE
// =========================================

          _actionButton(
            text: AppLanguageKeys.delete,
            icon: Icons.delete_outline,
            color: Colors.red,
            onTap: onTapDelete,
          ),
        ],
      ),
    );
  }

  // ===================================================
  // ACTION BUTTON
  // ===================================================

  Widget _actionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 100,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: onTap == null
                ? AppColors.greyColor.withOpacity(0.08)
                : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: onTap == null
                  ? AppColors.greyColor
                  : color,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: onTap == null
                    ? AppColors.greyColor
                    : color,
              ),

              const SizedBox(width: 5),

              Flexible(
                child: TextInAppWidget(
                  text: text,
                  textSize: 11,
                  fontWeightIndex:
                  FontSelectionData.mediumFontFamily,
                  textColor: onTap == null
                      ? AppColors.greyColor
                      : color,
                  isTextCenter: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _detailsButton({
    required VoidCallback? onTap,
    String? nameButton,
  }) {

    return SizedBox(
      width: 110,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
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
    );
  }
}