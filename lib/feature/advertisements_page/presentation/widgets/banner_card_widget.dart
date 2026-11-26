import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/get_banners_models/banner_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class BannerCardWidget extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BannerCardWidget({
    super.key,
    required this.banner,
    required this.onEdit,
    required this.onDelete,
  });

  bool get _isActive {
    final now = DateTime.now();
    final start = banner.startDate;
    final end = banner.endDate;
    if (start == null && end == null) return true;
    if (start != null && end != null) {
      return now.isAfter(start.subtract(const Duration(minutes: 1))) &&
          now.isBefore(end.add(const Duration(days: 1)));
    }
    if (start != null) {
      return now.isAfter(start.subtract(const Duration(minutes: 1)));
    }
    if (end != null) {
      return now.isBefore(end.add(const Duration(days: 1)));
    }
    return true;
  }

  bool get _isUpcoming {
    final now = DateTime.now();
    final start = banner.startDate;
    return start != null && start.isAfter(now);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isActive;
    final isUpcoming = _isUpcoming;

    final Color statusColor = isUpcoming
        ? AppColors.blueColor
        : (isActive ? AppColors.greenColor : AppColors.darkGreyColor);

    final String statusText =
        isUpcoming ? 'قادم' : (isActive ? 'نشط' : 'منتهي');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Image with overlay badges & actions
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 8,
                  child: banner.image != null
                      ? Image.memory(
                          banner.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallbackImage(),
                        )
                      : _fallbackImage(),
                ),
              ),

              // Status Badge (Top Start)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      TextInAppWidget(
                        text: statusText,
                        textSize: 11,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Actions (Top Left)
              Positioned(
                top: 10,
                left: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.blackColor.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppColors.orangeColor,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                          tooltip: LocaleKeys.edit.tr(),
                          onPressed: onEdit,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.blackColor.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: AppColors.redColor,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                          tooltip: LocaleKeys.delete.tr(),
                          onPressed: onDelete,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Period info & details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardStroke),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: AppColors.orangeColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextInAppWidget(
                            text: 'من: ${_formatDate(banner.startDate)}',
                            textSize: 11,
                            fontWeightIndex: FontSelectionData.mediumFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardStroke),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.event_available_outlined,
                          size: 13,
                          color: AppColors.orangeColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextInAppWidget(
                            text: 'إلى: ${_formatDate(banner.endDate)}',
                            textSize: 11,
                            fontWeightIndex: FontSelectionData.mediumFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: AppColors.scaffoldColor,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: AppColors.greyColor,
        ),
      ),
    );
  }
}
