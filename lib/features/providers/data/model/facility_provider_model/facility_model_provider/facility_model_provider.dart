import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_provider_harag/screens/car_haraj_orders_page/car_haraj_orders_page.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_provider_harag/screens/cars_haraj_statistics_page/cars_haraj_statistics_page.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_cars_with_drivers_cubit/get_company_cars_with_drivers_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_drivers_cubit/get_company_drivers_cubit.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/cars_companies/cars_companies.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/company_statistics/company_statistics.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/content_companies/content_companies.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/drivers_companies/drivers_companies.dart';
import 'package:web_admin_san/features/company/presentation/pages/page_details_companies/screens/order_companies/order_companies.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/branch_cubit/branch_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/work_time_cubit/work_time_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/bank_account_provider/bank_account_provider.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/branches_providers/branches_providers.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/facility_data_content_provider/facility_data_content_provider.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/order_providers/order_providers.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/statistics_providers/statistics_providers.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/working_hours_providers/working_hours_providers.dart';
import '../../../../../../core/language/language_constant.dart';

class FacilityModelProvider {
  final String title;
  final Widget content;

  FacilityModelProvider({required this.title, required this.content});
}

List<FacilityModelProvider> facilityTabsCompany(int companyId) => [
      //CompanyStatistics
      FacilityModelProvider(
        title: AppLanguageKeys.statistics,
        content: CompanyStatistics(
          companyId: companyId,
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.facilityDataKey,
        content: BlocProvider(
          create: (_) => GetUserInfoCubit()
            ..getUserInfo(
                request: GetUserInfoRequest(userId: companyId, userType: 2)),
          child: ContentCompanies(
            company: companyId,
          ),
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.allOrders,
        content: OrderCompanies(
          companyId: companyId,
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.cars,
        content: BlocProvider(
          create: (_) => GetCompanyCarsWithDriversCubit()
            ..getCompanyCarsWithDrivers(companyId: companyId),
          child: CarsCompanies(
            companyId: companyId,
          ),
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.drivers,
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
        title: AppLanguageKeys.statistics,
        content: CarsHarajStatisticsPage(
          providerID: providerID,
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.allOrders,
        content: CarHarajOrdersPage(
          providerID: providerID,
        ),
      ),
    ];

List<FacilityModelProvider> facilityTabsProviders(int providerID) => [
      FacilityModelProvider(
        title: AppLanguageKeys.statistics,
        content: StatisticsProviders(
          providerID: providerID,
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.facilityDataKey,
        content: FacilityDataContentProvider(
          providerID: providerID,
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.allOrders,
        content: OrderProviders(
          providerId: providerID,
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.branches,
        content: BlocProvider(
          create: (_) =>
              BranchCubit()..getProviderBranches(providerId: providerID),
          child: BranchesProviders(
            providerID: providerID,
          ),
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.workingHours,
        content: BlocProvider(
          create: (context) => UpdateWorkTimeCubit(providerId: providerID),
          child: WorkingHoursProviders(
            providerID: providerID,
          ),
        ),
      ),
      FacilityModelProvider(
        title: AppLanguageKeys.bankAccount,
        content: BlocProvider(
          create: (_) => GetUserInfoCubit()
            ..getUserInfo(
                request: GetUserInfoRequest(userId: providerID, userType: 4)),
          child: BankAccountProvider(
            providerID: providerID,
          ),
        ),
      ),
    ];
