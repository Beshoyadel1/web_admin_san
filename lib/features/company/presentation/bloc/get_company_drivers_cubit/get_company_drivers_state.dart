
import 'package:web_admin_san/features/company/data/model/get_company_drivers_model/get_company_drivers_model.dart';

sealed class GetCompanyDriversState {}

final class GetCompanyDriversInitial extends GetCompanyDriversState {}

final class GetCompanyDriversLoading extends GetCompanyDriversState {}

final class GetCompanyDriversSuccess extends GetCompanyDriversState {
  final GetCompanyDriversModel data;

  GetCompanyDriversSuccess(this.data,);
}

final class GetCompanyDriversFailure extends GetCompanyDriversState {
  final String error;

  GetCompanyDriversFailure(this.error,);
}