import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';

sealed class GetCompanyCarGroupsState {}

final class GetCompanyCarGroupsInitial extends GetCompanyCarGroupsState {}

final class GetCompanyCarGroupsLoading extends GetCompanyCarGroupsState {}

final class GetCompanyCarGroupsSuccess extends GetCompanyCarGroupsState {
  final List<CarGroupModel> carGroups;

  GetCompanyCarGroupsSuccess(this.carGroups);
}

final class GetCompanyCarGroupsFailure extends GetCompanyCarGroupsState {
  final String message;

  GetCompanyCarGroupsFailure(this.message);
}
