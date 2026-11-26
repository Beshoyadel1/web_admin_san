import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class LicenceImagePreviewDialog extends StatelessWidget {
  final Uint8List imageBytes;
  final String? title;

  const LicenceImagePreviewDialog({
    super.key,
    required this.imageBytes,
    this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required Uint8List imageBytes,
    String? title,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => LicenceImagePreviewDialog(
        imageBytes: imageBytes,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? LocaleKeys.licenceImagePreview.tr();

    return Dialog(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
          maxHeight: 700,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    color: AppColors.orangeColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    displayTitle,
                    style: const TextStyle(
                      color: AppColors.darkColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.darkGreyColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.veryLightGreyColor),

            // Image with interactive viewer
            Expanded(
              child: Container(
                color: AppColors.scaffoldColor,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.broken_image_rounded,
                              size: 48,
                              color: AppColors.darkGreyColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.failedToLoadLicenceImage.tr(),
                              style: const TextStyle(
                                  color: AppColors.darkGreyColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangeColor,
                        foregroundColor: AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(LocaleKeys.close.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
