import 'package:flutter/material.dart';
import '../helpers/colors/app_colors.dart';
import '../helpers/themes/fonts.dart';
import '../helpers/themes/text_styles.dart';

/// Reusable pagination component adapted from company project (sun_dashboard_company).
/// Fully responsive, pure Flutter widget without external package dependencies.
class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final bool hideIfSinglePage;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.hideIfSinglePage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages < 1 || (hideIfSinglePage && totalPages <= 1)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPageList(),
      ),
    );
  }

  List<Widget> _buildPageList() {
    final List<Widget> list = [];
    final int safeCurrentPage = currentPage.clamp(1, totalPages);

    // Always show first page
    list.add(_buildPageButton(1, safeCurrentPage));

    // Determine the start and end of the middle block
    int start = safeCurrentPage - 2;
    int end = safeCurrentPage + 2;

    // Adjust start if it conflicts with the first page (1)
    if (start <= 2) {
      start = 2;
    } else {
      list.add(_buildEllipsis());
    }

    // Adjust end if it conflicts with the last page
    if (end >= totalPages - 1) {
      end = totalPages - 1;
    }

    for (int i = start; i <= end; i++) {
      list.add(_buildPageButton(i, safeCurrentPage));
    }

    // Add ellipsis before last page if needed
    if (end < totalPages - 1) {
      list.add(_buildEllipsis());
    }

    // Always show last page if totalPages > 1
    if (totalPages > 1) {
      list.add(_buildPageButton(totalPages, safeCurrentPage));
    }

    return list;
  }

  Widget _buildPageButton(int page, int safeCurrentPage) {
    final bool isActive = page == safeCurrentPage;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (!isActive) {
            onPageChanged(page);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.orangeColor : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isActive ? AppColors.orangeColor : AppColors.lightGreyColor,
            ),
          ),
          child: TextInAppWidget(
            text: '$page',
            textColor: isActive ? AppColors.whiteColor : AppColors.darkColor,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextInAppWidget(
        text: '...',
        textColor: AppColors.darkGreyColor,
        fontWeightIndex: FontSelectionData.mediumFontFamily,
        textSize: 14,
      ),
    );
  }
}

/// Backward compatibility alias matching company project name.
typedef PaginationBar = AppPagination;
