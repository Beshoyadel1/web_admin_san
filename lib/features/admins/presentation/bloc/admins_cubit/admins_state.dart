import 'package:web_admin_san/features/admins/data/model/get_all_admins_models/get_all_admins_models.dart';

abstract class AdminsState {
  const AdminsState();
}

class AdminsInitial extends AdminsState {
  const AdminsInitial();
}

class AdminsLoading extends AdminsState {
  const AdminsLoading();
}

class AdminsSuccess extends AdminsState {
  final List<AdminModel> admins;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  const AdminsSuccess({
    required this.admins,
    required this.currentPage,
    required this.pageCount,
    required this.totalCount,
  });
}

class AdminsError extends AdminsState {
  final String error;

  const AdminsError({
    required this.error,
  });
}
class AdminsUpdateLoading extends AdminsState {
  const AdminsUpdateLoading();
}

class AdminsUpdateSuccess extends AdminsState {
  final String message;

  const AdminsUpdateSuccess({
    required this.message,
  });
}

class AdminsUpdateError extends AdminsState {
  final String error;

  const AdminsUpdateError({
    required this.error,
  });
}
class AdminsCreateLoading extends AdminsState {
  const AdminsCreateLoading();
}

class AdminsCreateSuccess extends AdminsState {
  final String message;

  const AdminsCreateSuccess({
    required this.message,
  });
}

class AdminsCreateError extends AdminsState {
  final String error;

  const AdminsCreateError({
    required this.error,
  });
}