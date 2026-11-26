import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../helpers/colors/app_colors.dart';
import '../helpers/themes/text_styles.dart';

class EmptyStateView extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action;

  const EmptyStateView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.scaffoldColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.veryLightGreyColor,
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.darkGreyColor,
              ),
            ),
            const SizedBox(height: 16),
            TextInAppWidget(
              text: message.tr(),
              textSize: 15,
              textColor: AppColors.darkGreyColor,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
