import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/widgets/coupon_detail_item_tile.dart';

class CouponDiscountRulesCard extends StatelessWidget {
  final CouponModel coupon;

  const CouponDiscountRulesCard({
    super.key,
    required this.coupon,
  });

  String _formatNumber(double? value) {
    if (value == null) return '-';
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isPercentage = coupon.discountType == DiscountType.percentage;
    final discountUnit = isPercentage ? '%' : LocaleKeys.sarCurrency.tr();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sell_outlined,
                size: 20,
                color: AppColors.orangeColor,
              ),
              const SizedBox(width: 8),
              TextInAppWidget(
                text: LocaleKeys.discountRulesAndValues.tr(),
                textSize: 15,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 380;
              return Column(
                children: [
                  if (isWide)
                    Row(
                      children: [
                        Expanded(
                          child: CouponDetailItemTile(
                            icon: Icons.percent,
                            label: LocaleKeys.discountValue,
                            value:
                                '${_formatNumber(coupon.discountValue)} $discountUnit',
                            iconColor: AppColors.orangeColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CouponDetailItemTile(
                            icon: Icons.vertical_align_top,
                            label: LocaleKeys.maxDiscountValue,
                            value:
                                '${_formatNumber(coupon.maxDiscountValue)} ${LocaleKeys.sarCurrency.tr()}',
                            iconColor: AppColors.greenColor,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    CouponDetailItemTile(
                      icon: Icons.percent,
                      label: LocaleKeys.discountValue,
                      value:
                          '${_formatNumber(coupon.discountValue)} $discountUnit',
                      iconColor: AppColors.orangeColor,
                    ),
                    const SizedBox(height: 12),
                    CouponDetailItemTile(
                      icon: Icons.vertical_align_top,
                      label: LocaleKeys.maxDiscountValue,
                      value:
                          '${_formatNumber(coupon.maxDiscountValue)} ${LocaleKeys.sarCurrency.tr()}',
                      iconColor: AppColors.greenColor,
                    ),
                  ],
                  const SizedBox(height: 12),
                  CouponDetailItemTile(
                    icon: Icons.shopping_basket_outlined,
                    label: LocaleKeys.minValueToApply,
                    value:
                        '${_formatNumber(coupon.minValueToApply)} ${LocaleKeys.sarCurrency.tr()}',
                    iconColor: AppColors.blueColor,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
