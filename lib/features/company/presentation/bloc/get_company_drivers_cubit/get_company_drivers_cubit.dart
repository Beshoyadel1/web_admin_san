import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/company/data/datasource/get_company_drivers_datasource/get_company_drivers_datasource.dart';
import 'package:web_admin_san/features/company/data/model/get_company_drivers_model/get_company_drivers_model.dart';
import 'package:web_admin_san/features/company/data/request/get_company_drivers_request/get_company_drivers_request.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_company_drivers_cubit/get_company_drivers_state.dart';

class GetCompanyDriversCubit extends Cubit<GetCompanyDriversState> {
  GetCompanyDriversCubit()
      : super(GetCompanyDriversInitial());

  GetCompanyDriversModel? model;

  Future<void> getCompanyDrivers({
    required int companyId,
  }) async {
    emit(GetCompanyDriversLoading());

    try {
      model = await getCompanyDriversFunction(
        request: GetCompanyDriversRequest(
          companyId: companyId,
        ),
      );

      emit(GetCompanyDriversSuccess(model!));
    } catch (e) {
      emit(GetCompanyDriversFailure(e.toString()));
    }
  }
}