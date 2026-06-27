
import 'package:web_admin_san/features/company/data/model/get_company_cars_with_drivers_model/get_company_cars_with_drivers_model.dart';

abstract class GetCompanyCarsWithDriversState {}

class GetCompanyCarsWithDriversInitial
    extends GetCompanyCarsWithDriversState {}

class GetCompanyCarsWithDriversLoading
    extends GetCompanyCarsWithDriversState {}

class GetCompanyCarsWithDriversSuccess
    extends GetCompanyCarsWithDriversState {
  final GetCompanyCarsWithDriversModel model;

  GetCompanyCarsWithDriversSuccess(this.model);
}

class GetCompanyCarsWithDriversFailure
    extends GetCompanyCarsWithDriversState {
  final String message;

  GetCompanyCarsWithDriversFailure(this.message);
}