import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'provider_sparkline_painter.dart';

class ProviderServiceKpiCard extends StatelessWidget {
  final String title;
  final int orderCount;
  final double totalAmount;
  final double percentage;
  final bool isIncrease;
  final Color primaryColor;
  final String image;
  final String? countUnit;

  const ProviderServiceKpiCard({
    super.key,
    required this.title,
    required this.orderCount,
    required this.totalAmount,
    required this.percentage,
    required this.isIncrease,
    required this.primaryColor,
    required this.image,
    this.countUnit,
  });

  @override
  Widget build(BuildContext context) {
    final unit = countUnit ?? LocaleKeys.order.tr();
    final trendDirection =
        isIncrease ? LocaleKeys.increase.tr() : LocaleKeys.decrease.tr();
    final trendText =
        '$trendDirection ${percentage.abs().toStringAsFixed(percentage.truncateToDouble() == percentage ? 0 : 1)}%';

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Sparkline Wave
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 95,
            child: CustomPaint(
              painter: ProviderSparklinePainter(
                color: primaryColor,
                isIncrease: isIncrease,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Icon & Service Title)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: primaryColor.withValues(alpha: 0.12),
                      child: Image.asset(
                        image,
                        width: 20,
                        height: 20,
                        color: primaryColor,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.business_center_rounded,
                          size: 20,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$orderCount $unit',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Bottom Row: Trend Badge and Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Trend Badge
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: primaryColor,
                                child: Icon(
                                  isIncrease
                                      ? Icons.north_east_rounded
                                      : Icons.south_east_rounded,
                                  size: 10,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                trendText,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Amount
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              totalAmount.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              AppImageKeys.coin,
                              width: 14,
                              height: 14,
                              color: primaryColor,
                              colorBlendMode: BlendMode.srcIn,
                              errorBuilder: (_, __, ___) => Text(
                                LocaleKeys.sarCurrency.tr(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
