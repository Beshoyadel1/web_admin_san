import 'package:web_admin_san/feature/companies_page/data/model/get_driver_details_model/get_driver_details_model.dart';

abstract class GetDriverDetailsState {}

class GetDriverDetailsInitial extends GetDriverDetailsState {}

class GetDriverDetailsLoading extends GetDriverDetailsState {}

class GetDriverDetailsSuccess extends GetDriverDetailsState {
  final GetDriverDetailsModel model;

  GetDriverDetailsSuccess(this.model);
}

class GetDriverDetailsFailure extends GetDriverDetailsState {
  final String message;

  GetDriverDetailsFailure(this.message);
}
