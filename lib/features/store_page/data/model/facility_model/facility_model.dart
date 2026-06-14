import 'package:flutter/material.dart';
import '../../../../../../../../../features/store_page/presentation/pages/store_widgets/facility_account/tabs/facility_data_content.dart';
import '../../../../../../core/language/language_constant.dart';

class FacilityModel {
  final String title;
  final Widget content;

  FacilityModel({required this.title, required this.content});
}

final List<FacilityModel> facilityTabs = [
  FacilityModel(
    title: AppLanguageKeys.facilityDataKey,
    content: const FacilityDataContent(),
  ),

  // FacilityModel(
  //   title: AppLanguageKeys.branchesKey,
  //   content: MultiBlocProvider(
  //     providers: [
  //       BlocProvider(create: (_) => BranchCubit()..getProviderBranches()),
  //     ],
  //     child: const BranchesContent(),
  //   ),
  // ),
  // FacilityModel(
  //   title: AppLanguageKeys.workingHoursKey,
  //   content: BlocProvider(
  //       create: (context) => UpdateWorkTimeCubit(),
  //       child: const WorkingHoursContent(),
  //     ),
  //   ),
  // FacilityModel(
  //     title: AppLanguageKeys.bankAccountKey,
  //     content: const BankAccountContent()),
];


final List<FacilityModel> facilityTabsCompleteData = [

  FacilityModel(
    title: AppLanguageKeys.facilityDataKey,
    content: const FacilityDataContent(),
  ),

  // FacilityModel(
  //   title: AppLanguageKeys.branchesKey,
  //   content: MultiBlocProvider(
  //     providers: [
  //       BlocProvider(create: (_) => BranchCubit()..getProviderBranches()),
  //     ],
  //     child: const BranchesContent(),
  //   ),
  // ),
  // FacilityModel(
  //   title: AppLanguageKeys.workingHoursKey,
  //   content: BlocProvider(
  //     create: (context) => UpdateWorkTimeCubit(),
  //     child: const WorkingHoursContent(),
  //   ),
  // ),
  // FacilityModel(
  //     title: AppLanguageKeys.bankAccountKey,
  //     content: const BankAccountContent()
  // ),
];