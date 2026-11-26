import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/coupons_page/data/model/coupon_model/coupon_model.dart';
import 'package:web_admin_san/feature/coupons_page/presentation/pages/page_details_coupons/widgets/coupon_detail_item_tile.dart';

class CouponUsageValidityCard extends StatelessWidget {
  final CouponModel coupon;

  const CouponUsageValidityCard({
    super.key,
    required this.coupon,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.rule_folder_outlined,
                size: 20,
                color: AppColors.orangeColor,
              ),
              const SizedBox(width: 8),
              TextInAppWidget(
                text: LocaleKeys.usageAndValidityLimits.tr(),
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
                            icon: Icons.groups_outlined,
                            label: LocaleKeys.usersUseCount,
                            value:
                                '${coupon.usersUseCount ?? 0} ${LocaleKeys.uses.tr()}',
                            iconColor: AppColors.orangeColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CouponDetailItemTile(
                            icon: Icons.person_outline,
                            label: LocaleKeys.oneUserUseCount,
                            value:
                                '${coupon.oneUserUseCount ?? 0} ${LocaleKeys.perUser.tr()}',
                            iconColor: AppColors.purpleColor,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    CouponDetailItemTile(
                      icon: Icons.groups_outlined,
                      label: LocaleKeys.usersUseCount,
                      value:
                          '${coupon.usersUseCount ?? 0} ${LocaleKeys.uses.tr()}',
                      iconColor: AppColors.orangeColor,
                    ),
                    const SizedBox(height: 12),
                    CouponDetailItemTile(
                      icon: Icons.person_outline,
                      label: LocaleKeys.oneUserUseCount,
                      value:
                          '${coupon.oneUserUseCount ?? 0} ${LocaleKeys.perUser.tr()}',
                      iconColor: AppColors.purpleColor,
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (isWide)
                    Row(
                      children: [
                        Expanded(
                          child: CouponDetailItemTile(
                            icon: Icons.calendar_today,
                            label: LocaleKeys.startDate,
                            value: _formatDate(coupon.couponStartDate),
                            iconColor: AppColors.greenColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CouponDetailItemTile(
                            icon: Icons.event_available,
                            label: LocaleKeys.endDate,
                            value: _formatDate(coupon.couponEndDate),
                            iconColor: AppColors.redColor,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    CouponDetailItemTile(
                      icon: Icons.calendar_today,
                      label: LocaleKeys.startDate,
                      value: _formatDate(coupon.couponStartDate),
                      iconColor: AppColors.greenColor,
                    ),
                    const SizedBox(height: 12),
                    CouponDetailItemTile(
                      icon: Icons.event_available,
                      label: LocaleKeys.endDate,
                      value: _formatDate(coupon.couponEndDate),
                      iconColor: AppColors.redColor,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
