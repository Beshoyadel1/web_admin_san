import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/data/datasource/get_company_general_statistics_datasource/get_company_general_statistics_datasource.dart';
import 'package:web_admin_san/features/company/data/request/get_company_general_statistics_request/get_company_general_statistics_request.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_general_statistics_cubit/get_company_general_statistics_state.dart';

class GetCompanyGeneralStatisticsCubit
    extends Cubit<GetCompanyGeneralStatisticsState> {
  GetCompanyGeneralStatisticsCubit()
      : super(GetCompanyGeneralStatisticsInitial());

  Future<void> getCompanyGeneralStatistics({
    required int companyId,
  }) async {
    if (isClosed) return;

    emit(GetCompanyGeneralStatisticsLoading());

    try {
      final result = await getCompanyGeneralStatisticsFunction(
        request: GetCompanyGeneralStatisticsRequest(
          companyId: companyId,
        ),
      );

      if (isClosed) return;

      emit(
        GetCompanyGeneralStatisticsSuccess(
          data: result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        GetCompanyGeneralStatisticsError(
          e.toString(),
        ),
      );
    }
  }
}