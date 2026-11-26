import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/presentation/widgets/communication_header_bar.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/presentation/widgets/policy_content_editor_card.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/presentation/widgets/policy_tabs_bar.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/view_model/all_pages_about_cubit/all_pages_about_cubit.dart';
import 'package:web_admin_san/feature/communication_and_policies_page/view_model/all_pages_about_cubit/all_pages_about_state.dart';

class CommunicationTabs extends StatelessWidget {
  const CommunicationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllPagesAboutCubit, AllPagesAboutState>(
      builder: (context, state) {
        final cubit = context.read<AllPagesAboutCubit>();

        if (state is AllPagesAboutLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.orangeColor),
              ),
            ),
          );
        }

        if (state is AllPagesAboutError) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardStroke),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.errorRedColor,
                  ),
                  const SizedBox(height: 12),
                  TextInAppWidget(
                    text: state.message,
                    textSize: 14,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                  const SizedBox(height: 16),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangeColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => cubit.getAllPagesAbout(),
                      icon: const Icon(Icons.refresh,
                          color: AppColors.whiteColor),
                      label: const TextInAppWidget(
                        text: 'إعادة المحاولة',
                        textSize: 13,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AllPagesAboutSuccess) {
          final pages = state.pages;

          if (pages.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: TextInAppWidget(
                  text: 'لا توجد صفحات مضافة حالياً',
                  textSize: 16,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.darkGreyColor,
                ),
              ),
            );
          }

          final safeIndex =
              (cubit.selectedIndex >= 0 && cubit.selectedIndex < pages.length)
                  ? cubit.selectedIndex
                  : 0;
          final currentPage = pages[safeIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommunicationHeaderBar(
                pagesCount: pages.length,
                onRefresh: () => cubit.getAllPagesAbout(),
              ),
              const SizedBox(height: 20),
              PolicyTabsBar(
                pages: pages,
                selectedIndex: safeIndex,
                onTabSelected: (index) => cubit.selectPage(index),
              ),
              const SizedBox(height: 20),
              PolicyContentEditorCard(
                page: currentPage,
                isSaving: cubit.isUpdating,
                onSave: (updatedPage) =>
                    cubit.updatePageAbout(page: updatedPage),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
