import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ProviderRatingCard extends StatelessWidget {
  final double averageRate;

  const ProviderRatingCard({
    super.key,
    required this.averageRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Stack(
        children: [
          // Decorative Sparkles
          Positioned(
            left: 8,
            top: 4,
            bottom: 4,
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                AppImageKeys.starsIcons,
                width: 70,
                color: AppColors.orangeColor,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.auto_awesome,
                  size: 32,
                  color: AppColors.orangeColor,
                ),
              ),
            ),
          ),

          // Rating Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.servicesRatingKey.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    averageRate.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.orangeColor,
                    size: 38,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
