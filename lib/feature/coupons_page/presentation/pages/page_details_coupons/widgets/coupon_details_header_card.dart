import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/widgets/coupon_discount_type_widget.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/widgets/coupon_status_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CouponDetailsHeaderCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onEdit;

  const CouponDetailsHeaderCard({
    super.key,
    required this.coupon,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.darkColor.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ticket Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.orangeColor,
                  AppColors.orangeColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orangeColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.confirmation_num_outlined,
              size: 28,
              color: AppColors.whiteColor,
            ),
          ),
          const SizedBox(width: 16),
          // Code & Metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextInAppWidget(
                      text: coupon.couponCode ?? '-',
                      textSize: 20,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    // ID Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.darkColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: TextInAppWidget(
                        text: '#${coupon.couponId ?? 0}',
                        textSize: 12,
                        textColor: AppColors.darkGreyColor,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                      ),
                    ),
                    // Discount Type Badge
                    CouponDiscountTypeWidget(
                      discountType: coupon.discountType,
                    ),
                    // Status Badge
                    CouponStatusWidget(
                      isActive: coupon.isActive,
                      endDate: coupon.couponEndDate,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const TextInAppWidget(
                  text: LocaleKeys.couponCodeForCustomerApp,
                  textSize: 12,
                  textColor: AppColors.darkGreyColor,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Edit Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.whiteColor,
              ),
              label: const TextInAppWidget(
                text: LocaleKeys.edit,
                textSize: 13,
                textColor: AppColors.whiteColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
