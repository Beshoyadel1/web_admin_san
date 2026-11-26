import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/data/datasource/get_company_cars_with_drivers_datasource/get_company_cars_with_drivers_datasource.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_cars_with_drivers_model/get_company_cars_with_drivers_model.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_company_cars_with_drivers_request/get_company_cars_with_drivers_request.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_cars_with_drivers_cubit/get_company_cars_with_drivers_state.dart';

class GetCompanyCarsWithDriversCubit
    extends Cubit<GetCompanyCarsWithDriversState> {
  GetCompanyCarsWithDriversCubit() : super(GetCompanyCarsWithDriversInitial());

  GetCompanyCarsWithDriversModel? model;

  Future<void> getCompanyCarsWithDrivers({
    required int companyId,
  }) async {
    emit(GetCompanyCarsWithDriversLoading());

    try {
      model = await getCompanyCarsWithDriversFunction(
        request: GetCompanyCarsWithDriversRequest(
          companyId: companyId,
        ),
      );

      emit(GetCompanyCarsWithDriversSuccess(model!));
    } catch (e) {
      emit(
        GetCompanyCarsWithDriversFailure(
          e.toString(),
        ),
      );
    }
  }
}
