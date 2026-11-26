import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/data/datasource/get_company_drivers_datasource/get_company_drivers_datasource.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_company_drivers_model/get_company_drivers_model.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_company_drivers_request/get_company_drivers_request.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_drivers_cubit/get_company_drivers_state.dart';

class GetCompanyDriversCubit extends Cubit<GetCompanyDriversState> {
  GetCompanyDriversCubit() : super(GetCompanyDriversInitial());

  GetCompanyDriversModel? model;
  bool includeNotActive = false;

  Future<void> getCompanyDrivers({
    required int companyId,
    bool? includeNotActive,
  }) async {
    if (includeNotActive != null) {
      this.includeNotActive = includeNotActive;
    }

    if (isClosed) return;
    emit(GetCompanyDriversLoading());

    try {
      model = await getCompanyDriversFunction(
        request: GetCompanyDriversRequest(
          companyId: companyId,
          includeNotActive: this.includeNotActive,
        ),
      );

      if (isClosed) return;
      emit(GetCompanyDriversSuccess(model!));
    } catch (e) {
      if (isClosed) return;
      emit(GetCompanyDriversFailure(e.toString()));
    }
  }

  void toggleIncludeNotActive({required int companyId}) {
    getCompanyDrivers(
      companyId: companyId,
      includeNotActive: !includeNotActive,
    );
  }
}
