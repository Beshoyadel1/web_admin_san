import 'package:web_admin_san/features/company/data/model/get_all_companies_model/get_all_companies_model.dart';

abstract class GetAllCompaniesState {}

class GetAllCompaniesInitial extends GetAllCompaniesState {}

class GetAllCompaniesLoading extends GetAllCompaniesState {}

class GetAllCompaniesSuccess extends GetAllCompaniesState {
  final List<GetAllCompanies> companies;
  final int currentPage;
  final int pageCount;
  final int totalCount;

  GetAllCompaniesSuccess({
    required this.companies,
    required this.currentPage,
    required this.pageCount,
    required this.totalCount,
  });
}

class GetAllCompaniesError extends GetAllCompaniesState {
  final String error;

  GetAllCompaniesError(this.error);
}