import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({
    super.key,
    this.onConfirm,
  });

  final VoidCallback? onConfirm;

  static bool _isShowing = false;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) async {
    if (_isShowing) return;
    _isShowing = true;

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (dialogContext) {
          return SessionExpiredDialog(
            onConfirm: onConfirm,
          );
        },
      );
    } finally {
      _isShowing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardStroke,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _SessionExpiredIconBadge(),
                const SizedBox(height: 18),
                const TextInAppWidget(
                  text: LocaleKeys.sessionExpiredTitle,
                  textSize: 19,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.darkColor,
                  isTextCenter: true,
                ),
                const SizedBox(height: 10),
                const TextInAppWidget(
                  text: LocaleKeys.sessionExpiredMessage,
                  textSize: 14,
                  textColor: AppColors.darkGreyColor,
                  isTextCenter: true,
                ),
                const SizedBox(height: 24),
                _SessionExpiredActionButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    onConfirm?.call();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionExpiredIconBadge extends StatelessWidget {
  const _SessionExpiredIconBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.CircleLightorangeColor,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.lock_clock_outlined,
          color: AppColors.orangeColor,
          size: 32,
        ),
      ),
    );
  }
}

class _SessionExpiredActionButton extends StatelessWidget {
  const _SessionExpiredActionButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeColor,
            foregroundColor: AppColors.whiteColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: const TextInAppWidget(
            text: LocaleKeys.loginAgain,
            textSize: 15,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            textColor: AppColors.whiteColor,
            isTextCenter: true,
          ),
        ),
      ),
    );
  }
}
