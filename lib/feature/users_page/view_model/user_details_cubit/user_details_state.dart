import 'package:web_admin_san/feature/users_page/data/model/user_details_model/user_details_model.dart';

abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsSuccess extends UserDetailsState {
  final UserDetailsResponse data;

  UserDetailsSuccess(this.data);
}

class UserDetailsFailure extends UserDetailsState {
  final String error;

  UserDetailsFailure(this.error);
}
