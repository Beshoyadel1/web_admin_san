import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_provider_harag/screens/car_haraj_orders_page/car_haraj_orders_page.dart';
import 'package:web_admin_san/features/cars_haraj_page/presentation/ui/page_details_provider_harag/screens/cars_haraj_statistics_page/cars_haraj_statistics_page.dart';
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
      // FacilityModelProvider(
      //   title: AppLanguageKeys.facilityDataKey,
      //   content: FacilityDataContentProvider(
      //     providerID: providerID,
      //   ),
      // ),
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
      // FacilityModelProvider(
      //   title: AppLanguageKeys.bankAccount,
      //   content: BankAccountProvider(
      //     providerID: providerID,
      //   ),
      // ),
    ];
