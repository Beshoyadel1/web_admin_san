import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/detail_section_card.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/screens/branch_card_item.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/screens/branch_details_dialog.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/branch_cubit/branch_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class BranchesAddedUi extends StatelessWidget {
  final int providerId;
  final BranchSuccess state;

  const BranchesAddedUi({
    super.key,
    required this.state,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    final branches = state.branches.where((b) => b.isActive == true).toList();

    return DetailSectionCard(
      title: LocaleKeys.branches.tr(),
      icon: Icons.store_mall_directory_rounded,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.orangeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.orangeColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          "${branches.length} ${LocaleKeys.branches.tr()}",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.orangeColor,
          ),
        ),
      ),
      child: branches.isEmpty
          ? const BranchesEmptyWidget()
          : LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 950;
                final cardWidth = isDesktop
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(branches.length, (index) {
                    final branch = branches[index];
                    return SizedBox(
                      width: cardWidth,
                      height: 230,
                      child: BranchCardItem(
                        branch: branch,
                        onViewDetails: () {
                          showBranchDetailsDialog(context, branch);
                        },
                      ),
                    );
                  }),
                );
              },
            ),
    );
  }
}

class BranchesEmptyWidget extends StatelessWidget {
  const BranchesEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightOrangeColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store_mall_directory_outlined,
                size: 40,
                color: AppColors.orangeColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.noBranchesYet.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
