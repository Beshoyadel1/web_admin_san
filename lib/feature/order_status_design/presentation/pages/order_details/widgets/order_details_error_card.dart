import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class OrderDetailsErrorCard extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const OrderDetailsErrorCard({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(28),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.redColor.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.redColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.redColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            TextInAppWidget(
              text: LocaleKeys.failedToLoadOrderDetails.tr(),
              textSize: 16,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.boldFontFamily,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextInAppWidget(
              text: errorMessage.isNotEmpty
                  ? errorMessage
                  : LocaleKeys.unexpectedErrorFetchingOrder.tr(),
              textSize: 13,
              textColor: AppColors.darkGreyColor,
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: AppColors.whiteColor,
                ),
                label: TextInAppWidget(
                  text: LocaleKeys.retry.tr(),
                  textSize: 13,
                  textColor: AppColors.whiteColor,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
