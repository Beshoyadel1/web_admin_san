import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/ui/car_haraj_orders_page/car_haraj_orders_page.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/ui/cars_haraj_statistics_page/cars_haraj_statistics_page.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_car_groups_cubit/get_company_car_groups_cubit.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_drivers_cubit/get_company_drivers_cubit.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/cars_companies/cars_companies.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/company_statistics/company_statistics.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/content_companies/content_companies.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/drivers_companies/drivers_companies.dart';
import 'package:web_admin_san/feature/companies_page/presentation/pages/page_details_companies/screens/order_companies/order_companies.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/screens/package_data_content/package_data_view.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/branch_cubit/branch_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/work_time_cubit/work_time_cubit.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/bank_account_provider/bank_account_provider.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/branches_providers/branches_providers.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/facility_data_content_provider/facility_data_content_provider.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/order_providers/order_providers.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/statistics_providers/statistics_providers.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/working_hours_providers/working_hours_providers.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class FacilityModelProvider {
  final String title;
  final Widget content;

  FacilityModelProvider({required this.title, required this.content});
}

List<FacilityModelProvider> packageTabDetails(int packageID) => [
      FacilityModelProvider(
        title: LocaleKeys.details,
        content: PackageDataContent(
          packageId: packageID,
        ),
      ),
    ];

const List<String> companyTabTitles = [
  LocaleKeys.statistics,
  LocaleKeys.facilityDataKey,
  LocaleKeys.allOrders,
  LocaleKeys.cars,
  LocaleKeys.drivers,
];

Widget buildCompanyTabContent(BuildContext context, int index, int companyId) {
  switch (index) {
    case 0:
      return CompanyStatistics(companyId: companyId);
    case 1:
      return ContentCompanies(company: companyId);
    case 2:
      return OrderCompanies(companyId: companyId);
    case 3:
      return BlocProvider(
        create: (_) => GetCompanyCarGroupsCubit()
          ..getCompanyCarGroups(companyId: companyId),
        child: CarsCompanies(companyId: companyId),
      );
    case 4:
      return BlocProvider(
        create: (_) =>
            GetCompanyDriversCubit()..getCompanyDrivers(companyId: companyId),
        child: DriversCompanies(companyId: companyId),
      );
    default:
      return const SizedBox.shrink();
  }
}

List<FacilityModelProvider> facilityTabsCompany(int companyId) => [
      FacilityModelProvider(
        title: LocaleKeys.statistics,
        content: CompanyStatistics(
          companyId: companyId,
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.facilityDataKey,
        content: ContentCompanies(
          company: companyId,
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.allOrders,
        content: OrderCompanies(
          companyId: companyId,
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.cars,
        content: BlocProvider(
          create: (_) => GetCompanyCarGroupsCubit()
            ..getCompanyCarGroups(companyId: companyId),
          child: CarsCompanies(
            companyId: companyId,
          ),
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.drivers,
        content: BlocProvider(
          create: (_) =>
              GetCompanyDriversCubit()..getCompanyDrivers(companyId: companyId),
          child: DriversCompanies(
            companyId: companyId,
          ),
        ),
      ),
    ];

List<FacilityModelProvider> facilityTabsProvidersHarag(int providerID) => [
      FacilityModelProvider(
        title: LocaleKeys.statistics,
        content: CarsHarajStatisticsPage(
          providerId: providerID,
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.allOrders,
        content: CarHarajOrdersPage(
          userId: providerID,
        ),
      ),
    ];

const List<String> providerTabTitles = [
  LocaleKeys.statistics,
  LocaleKeys.facilityDataKey,
  LocaleKeys.establishmentOrders,
  LocaleKeys.branches,
  LocaleKeys.workingHours,
  LocaleKeys.bankAccount,
];

Widget buildProviderTabContent(
    BuildContext context, int index, int providerID) {
  switch (index) {
    case 0:
      return StatisticsProviders(providerID: providerID);
    case 1:
      return FacilityDataContentProvider(providerID: providerID);
    case 2:
      return OrderProviders(providerId: providerID);
    case 3:
      return BlocProvider(
        create: (_) =>
            BranchCubit()..getProviderBranches(providerId: providerID),
        child: BranchesProviders(providerID: providerID),
      );
    case 4:
      return BlocProvider(
        create: (_) =>
            UpdateWorkTimeCubit(providerId: providerID)..getWorkTimes(),
        child: WorkingHoursProviders(providerID: providerID),
      );
    case 5:
      return BankAccountProvider(providerID: providerID);
    default:
      return const SizedBox.shrink();
  }
}

List<FacilityModelProvider> facilityTabsProviders(int providerID) => [
      FacilityModelProvider(
        title: LocaleKeys.statistics,
        content: StatisticsProviders(
          providerID: providerID,
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.facilityDataKey,
        content: FacilityDataContentProvider(
          providerID: providerID,
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.establishmentOrders,
        content: OrderProviders(
          providerId: providerID,
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.branches,
        content: BlocProvider(
          create: (_) =>
              BranchCubit()..getProviderBranches(providerId: providerID),
          child: BranchesProviders(
            providerID: providerID,
          ),
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.workingHours,
        content: BlocProvider(
          create: (context) =>
              UpdateWorkTimeCubit(providerId: providerID)..getWorkTimes(),
          child: WorkingHoursProviders(
            providerID: providerID,
          ),
        ),
      ),
      FacilityModelProvider(
        title: LocaleKeys.bankAccount,
        content: BankAccountProvider(
          providerID: providerID,
        ),
      ),
    ];
