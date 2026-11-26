import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
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
    this.onToggleStatus,
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
  final VoidCallback? onToggleStatus;

  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '---';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
          // ID
          SizedBox(
            width: 80,
            child: TitleWithSubTitle(
              title: LocaleKeys.identity,
              subTitle: couponId?.toString() ?? '---',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // Code
          SizedBox(
            width: 150,
            child: TitleWithSubTitle(
              title: LocaleKeys.couponCode,
              subTitle: couponCode ?? '---',
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // Start Date
          SizedBox(
            width: 130,
            child: TitleWithSubTitle(
              title: LocaleKeys.startDate,
              subTitle: _formatDate(startDate),
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // End Date
          SizedBox(
            width: 130,
            child: TitleWithSubTitle(
              title: LocaleKeys.endDate,
              subTitle: _formatDate(endDate),
              textSizeTitle: 12,
              titleColor: AppColors.greyColor,
              textSizeSubTitle: 14,
              subTitleColor: AppColors.darkColor,
            ),
          ),

          // Status with Quick Toggle
          SizedBox(
            width: 110,
            child: CouponStatusWidget(
              isActive: isActive,
              endDate: endDate,
              onTap: onToggleStatus,
            ),
          ),

          // Details Action
          _detailsButton(
            onTap: onTapDetails,
          ),

          // Edit Action
          _actionButton(
            text: LocaleKeys.edit,
            icon: Icons.edit_outlined,
            color: AppColors.orangeColor,
            onTap: onTapEdit,
          ),

          // Delete Action
          _actionButton(
            text: LocaleKeys.delete,
            icon: Icons.delete_outline,
            color: AppColors.redColor,
            onTap: onTapDelete,
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 100,
      child: MouseRegion(
        cursor:
            onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
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
                  ? AppColors.greyColor.withValues(alpha: 0.08)
                  : color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: onTap == null ? AppColors.greyColor : color,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: onTap == null ? AppColors.greyColor : color,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: TextInAppWidget(
                    text: text,
                    textSize: 11,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: onTap == null ? AppColors.greyColor : color,
                    isTextCenter: true,
                  ),
                ),
              ],
            ),
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
      child: MouseRegion(
        cursor:
            onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
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
                text: nameButton ?? LocaleKeys.details,
                textSize: 12,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.orangeColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
