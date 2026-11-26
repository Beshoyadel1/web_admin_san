import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_drivers_model/get_company_drivers_model.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_drivers_cubit/get_company_drivers_cubit.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_drivers_cubit/get_company_drivers_state.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_driver_details_cubit/get_driver_details_cubit.dart';
import 'package:web_admin_san/feature/companies_page/presentation/widgets/widget_design_list_drivers.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/drivers_companies/driver_details_page.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class DriversCompanies extends StatelessWidget {
  final int companyId;

  const DriversCompanies({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCompanyDriversCubit, GetCompanyDriversState>(
      builder: (context, state) {
        final cubit = context.read<GetCompanyDriversCubit>();
        final bool includeNotActive = cubit.includeNotActive;

        return RefreshIndicator(
          color: AppColors.orangeColor,
          onRefresh: () async {
            await cubit.getCompanyDrivers(companyId: companyId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Toolbar
                DriversCompaniesToolbar(
                  includeNotActive: includeNotActive,
                  onToggle: (val) {
                    cubit.toggleIncludeNotActive(companyId: companyId);
                  },
                ),
                const SizedBox(height: 14),

                if (state is GetCompanyDriversLoading)
                  const SizedBox(
                    height: 350,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orangeColor,
                      ),
                    ),
                  )
                else if (state is GetCompanyDriversFailure)
                  DriversCompaniesErrorView(
                    error: state.error,
                    onRetry: () {
                      cubit.getCompanyDrivers(companyId: companyId);
                    },
                  )
                else if (state is GetCompanyDriversSuccess) ...[
                  if (state.data.drivers.isEmpty)
                    DriversCompaniesEmptyView(
                      onRefresh: () {
                        cubit.getCompanyDrivers(companyId: companyId);
                      },
                    )
                  else
                    DriversCompaniesListView(
                      drivers: state.data.drivers,
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class DriversCompaniesToolbar extends StatelessWidget {
  final bool includeNotActive;
  final ValueChanged<bool> onToggle;

  const DriversCompaniesToolbar({
    super.key,
    required this.includeNotActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.people_outline_rounded,
                color: AppColors.orangeColor,
                size: 20,
              ),
              SizedBox(width: 8),
              TextInAppWidget(
                text: LocaleKeys.drivers,
                textSize: 15,
                fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                textColor: AppColors.blackColor,
              ),
            ],
          ),
          Row(
            children: [
              TextInAppWidget(
                text: LocaleKeys.includeInactiveDrivers.tr(),
                textSize: 13,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.darkGreyColor,
              ),
              const SizedBox(width: 8),
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: includeNotActive,
                  activeTrackColor: AppColors.orangeColor,
                  onChanged: onToggle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DriversCompaniesListView extends StatelessWidget {
  final List<CompanyDriverModel> drivers;

  const DriversCompaniesListView({
    super.key,
    required this.drivers,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        drivers.length,
        (index) {
          final driver = drivers[index];
          final brandName = isArabic
              ? (driver.car?.brandName ?? '')
              : (driver.car?.brandLatinName ?? '');

          final modelName = driver.car?.modelName ?? '';
          final carTitle =
              [brandName, modelName].where((s) => s.isNotEmpty).join(' - ');

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: WidgetDesignListDrivers(
              id: driver.id.toString(),
              name: driver.name,
              phone: driver.phone,
              email: driver.email,
              imageUser: driver.image,
              imageBrand: driver.car?.image,
              plateNo: driver.car?.plateNo,
              nameBrandModel: carTitle.isNotEmpty ? carTitle : '--',
              isActive: driver.isActive,
              onTabDetails: () {
                Navigator.push(
                  context,
                  NavigateToPageWidget(
                    BlocProvider(
                      create: (_) => GetDriverDetailsCubit()
                        ..getDriverDetails(driverId: driver.id),
                      child: DriverDetailsPage(
                        driverId: driver.id,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DriversCompaniesEmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const DriversCompaniesEmptyView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 56,
              color: AppColors.greyColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            TextInAppWidget(
              text: LocaleKeys.noDriversRegisteredForCompany.tr(),
              textSize: 15,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.darkGreyColor,
            ),
            const SizedBox(height: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, color: AppColors.orangeColor),
                label: TextInAppWidget(
                  text: LocaleKeys.retry.tr(),
                  textSize: 13,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.orangeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriversCompaniesErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const DriversCompaniesErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.redColor,
            ),
            const SizedBox(height: 10),
            TextInAppWidget(
              text: error,
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
    );
  }
}
