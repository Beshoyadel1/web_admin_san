import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/helpers/themes/fonts.dart';
import '../../../../core/helpers/themes/text_styles.dart';

class BrandEmptyView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subMessage;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const BrandEmptyView({
    super.key,
    required this.icon,
    required this.message,
    this.subMessage,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.scaffoldColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 42,
                color: AppColors.darkGreyColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 14),
            TextInAppWidget(
              text: message,
              textSize: 15,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.semiBoldFontFamily,
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 6),
              TextInAppWidget(
                text: subMessage!,
                textSize: 13,
                textColor: AppColors.darkGreyColor,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.orangeColor,
                    side: const BorderSide(color: AppColors.orangeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(retryLabel ?? LocaleKeys.retry.tr()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
