import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/data/datasource/get_car_groups_datasource/get_car_groups_datasource.dart';
import 'package:web_admin_san/feature/companies_page/data/model/car_group_model/car_group_model.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_company_car_groups_cubit/get_company_car_groups_state.dart';

class GetCompanyCarGroupsCubit extends Cubit<GetCompanyCarGroupsState> {
  GetCompanyCarGroupsCubit() : super(GetCompanyCarGroupsInitial());

  List<CarGroupModel> carGroups = [];

  Future<void> getCompanyCarGroups({
    required int companyId,
  }) async {
    emit(GetCompanyCarGroupsLoading());

    try {
      carGroups = await getCarGroupsFunction(companyId: companyId);
      if (isClosed) return;
      emit(GetCompanyCarGroupsSuccess(carGroups));
    } catch (e) {
      if (isClosed) return;
      emit(GetCompanyCarGroupsFailure(e.toString()));
    }
  }
}
