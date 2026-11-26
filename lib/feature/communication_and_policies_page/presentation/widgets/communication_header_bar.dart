import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';

class CommunicationHeaderBar extends StatelessWidget {
  final int pagesCount;
  final VoidCallback onRefresh;

  const CommunicationHeaderBar({
    super.key,
    required this.pagesCount,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: AppColors.greyColor200,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.blueColor100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.article_outlined,
                        color: AppColors.seaBlueColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: TextInAppWidget(
                        text: 'إدارة المحتوى والسياسات',
                        textSize: 18,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const TextInAppWidget(
                  text:
                      'تعديل نصوص صفحات التطبيق باللغتين العربية والإنجليزية لتحديثها فوراً',
                  textSize: 13,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textColor: AppColors.darkGreyColor,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommunicationCountBadge(count: pagesCount),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: AppColors.darkGreyColor),
                        onPressed: onRefresh,
                        tooltip: 'تحديث المحتوى',
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blueColor100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: AppColors.seaBlueColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInAppWidget(
                      text: 'إدارة المحتوى والسياسات',
                      textSize: 18,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    SizedBox(height: 4),
                    TextInAppWidget(
                      text:
                          'تعديل نصوص صفحات التطبيق (من نحن، الشروط والأحكام، سياسة الخصوصية، تواصل معنا) باللغتين العربية والإنجليزية',
                      textSize: 13,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                      textColor: AppColors.darkGreyColor,
                    ),
                  ],
                ),
              ),
              CommunicationCountBadge(count: pagesCount),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  icon: const Icon(Icons.refresh_rounded,
                      color: AppColors.darkGreyColor),
                  onPressed: onRefresh,
                  tooltip: 'تحديث المحتوى',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CommunicationCountBadge extends StatelessWidget {
  final int count;

  const CommunicationCountBadge({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightGreenColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greenColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.greenColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          TextInAppWidget(
            text: '$count صفحات نشطة',
            textSize: 12,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.greenColor,
          ),
        ],
      ),
    );
  }
}
