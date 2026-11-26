import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/tabs/facility_data_content.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class FacilityModel {
  final String title;
  final Widget content;

  FacilityModel({required this.title, required this.content});
}

final List<FacilityModel> facilityTabs = [
  FacilityModel(
    title: LocaleKeys.facilityDataKey,
    content: const FacilityDataContent(),
  ),
];
final List<FacilityModel> facilityTabsCompleteData = [
  FacilityModel(
    title: LocaleKeys.facilityDataKey,
    content: const FacilityDataContent(),
  ),
];
