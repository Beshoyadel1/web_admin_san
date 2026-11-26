import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/cars_companies/car_group_card_widget.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_car_groups_cubit/get_company_car_groups_cubit.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_car_groups_cubit/get_company_car_groups_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CarsCompanies extends StatelessWidget {
  final int companyId;

  const CarsCompanies({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.orangeColor,
      onRefresh: () async {
        await context.read<GetCompanyCarGroupsCubit>().getCompanyCarGroups(
              companyId: companyId,
            );
      },
      child: BlocBuilder<GetCompanyCarGroupsCubit, GetCompanyCarGroupsState>(
        builder: (context, state) {
          if (state is GetCompanyCarGroupsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.orangeColor),
            );
          }

          if (state is GetCompanyCarGroupsFailure) {
            return CompanyCarsErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<GetCompanyCarGroupsCubit>()
                    .getCompanyCarGroups(companyId: companyId);
              },
            );
          }

          if (state is GetCompanyCarGroupsSuccess) {
            final carGroups = state.carGroups;

            if (carGroups.isEmpty) {
              return CompanyCarsEmptyAllView(
                onRefresh: () {
                  context
                      .read<GetCompanyCarGroupsCubit>()
                      .getCompanyCarGroups(companyId: companyId);
                },
              );
            }

            return CompanyCarGroupsListView(carGroups: carGroups);
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class CompanyCarGroupsListView extends StatelessWidget {
  final List<CarGroupModel> carGroups;

  const CompanyCarGroupsListView({
    super.key,
    required this.carGroups,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop && carGroups.length > 1) {
          // 2-Column layout for desktop
          final half = (carGroups.length / 2).ceil();
          final leftCol = carGroups.sublist(0, half);
          final rightCol = carGroups.sublist(half);

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: leftCol
                        .map(
                          (group) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CarGroupCardWidget(carGroup: group),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: rightCol
                        .map(
                          (group) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CarGroupCardWidget(carGroup: group),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        }

        // Single column layout
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: carGroups
                .map(
                  (group) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CarGroupCardWidget(carGroup: group),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class CompanyCarsEmptyAllView extends StatelessWidget {
  final VoidCallback onRefresh;

  const CompanyCarsEmptyAllView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 64,
                color: AppColors.greyColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              const TextInAppWidget(
                text: LocaleKeys.cars_noCarGroups,
                textSize: 16,
                fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                textColor: AppColors.darkGreyColor,
              ),
              const SizedBox(height: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh, color: AppColors.orangeColor),
                  label: const TextInAppWidget(
                    text: LocaleKeys.retry,
                    textSize: 14,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyCarsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CompanyCarsErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
                color: AppColors.redColor,
              ),
              const SizedBox(height: 12),
              TextInAppWidget(
                text: message,
                textSize: 14,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.darkGreyColor,
                isTextCenter: true,
              ),
              const SizedBox(height: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    foregroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const TextInAppWidget(
                    text: LocaleKeys.retry,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
