import 'package:web_admin_san/features/providers/data/model/get_all_providers_models/get_all_providers_models/get_all_providers_models.dart';
import 'package:web_admin_san/features/users/data/model/get_all_users_models/get_all_users_models.dart';

abstract class GetAllUsersState {}

class GetAllUsersInitial extends GetAllUsersState {}

class GetAllUsersLoading extends GetAllUsersState {}

class GetAllUsersSuccess extends GetAllUsersState {
  final List<GetAllUsersModels> users;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  GetAllUsersSuccess({
    required this.users,
    required this.currentPage,
    required this.pageCount,
    required this.totalCount,
  });
}

class GetAllUsersError extends GetAllUsersState {
  final String error;

  GetAllUsersError(this.error);
}