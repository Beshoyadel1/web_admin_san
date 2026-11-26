import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/data/datasource/get_all_companies_datasource/get_all_companies_datasource.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_all_companies_request/get_all_companies_request.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_all_companies_cubit/get_all_companies_state.dart';

class GetAllCompaniesCubit extends Cubit<GetAllCompaniesState> {
  GetAllCompaniesCubit() : super(GetAllCompaniesInitial());

  String? currentSearch;
  bool? currentIsActive;
  DateTime? currentStartDate;
  DateTime? currentEndDate;

  Future<void> getAllCompanies({
    required int currentPage,
    String? searchTerm,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    bool updateFilters = false,
  }) async {
    if (updateFilters) {
      currentSearch = searchTerm;
      currentIsActive = isActive;
      currentStartDate = startDate;
      currentEndDate = endDate;
    } else {
      currentSearch = searchTerm ?? currentSearch;
      currentIsActive = isActive ?? currentIsActive;
      currentStartDate = startDate ?? currentStartDate;
      currentEndDate = endDate ?? currentEndDate;
    }

    if (isClosed) return;

    emit(GetAllCompaniesLoading());

    try {
      final result = await getAllCompaniesProviders(
        request: GetAllCompaniesRequest(
          pageNumber: currentPage,
          searchTerm: currentSearch,
          isActive: currentIsActive,
          startDate: currentStartDate,
          endDate: currentEndDate,
        ),
      );

      if (isClosed) return;

      emit(
        GetAllCompaniesSuccess(
          companies: result.company,
          currentPage: result.currentPage,
          pageCount: result.pageCount,
          totalCount: result.totalCount,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(GetAllCompaniesError(e.toString()));
    }
  }
}
