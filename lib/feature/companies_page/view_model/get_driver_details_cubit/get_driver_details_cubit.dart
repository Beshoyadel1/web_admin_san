import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/companies_page/data/datasource/get_driver_details_datasource/get_driver_details_datasource.dart';
import 'package:web_admin_san/feature/companies_page/data/model/get_driver_details_model/get_driver_details_model.dart';
import 'package:web_admin_san/feature/companies_page/data/request/get_driver_details_request/get_driver_details_request.dart';

import 'get_driver_details_state.dart';

class GetDriverDetailsCubit extends Cubit<GetDriverDetailsState> {
  GetDriverDetailsCubit() : super(GetDriverDetailsInitial());

  GetDriverDetailsModel? model;

  Future<void> getDriverDetails({
    required int driverId,
  }) async {
    emit(GetDriverDetailsLoading());

    try {
      model = await getDriverDetailsFunction(
        request: GetDriverDetailsRequest(
          driverId: driverId,
        ),
      );

      emit(
        GetDriverDetailsSuccess(model!),
      );
    } catch (e) {
      emit(
        GetDriverDetailsFailure(
          e.toString(),
        ),
      );
    }
  }
}
