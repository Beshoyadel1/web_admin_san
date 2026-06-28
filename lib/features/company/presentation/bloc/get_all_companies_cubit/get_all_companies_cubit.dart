import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/data/datasource/get_all_companies_datasource/get_all_companies_datasource.dart';
import 'package:web_admin_san/features/company/data/request/get_all_companies_request/get_all_companies_request.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_all_companies_cubit/get_all_companies_state.dart';

class GetAllCompaniesCubit extends Cubit<GetAllCompaniesState> {
  GetAllCompaniesCubit() : super(GetAllCompaniesInitial());

  Future<void> getAllCompanies({
    required int currentPage,
  }) async {
    if (isClosed) return;

    emit(GetAllCompaniesLoading());

    try {
      final result = await getAllCompaniesProviders(
        request: GetAllCompaniesRequest(
          pageNumber: currentPage,
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