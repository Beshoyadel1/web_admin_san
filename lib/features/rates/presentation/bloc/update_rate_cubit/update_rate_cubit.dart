import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/rates/data/datasource/update_rate_datasource/update_rate_datasource.dart';
import 'package:web_admin_san/features/rates/data/request/update_rate_request/update_rate_request.dart';


part 'update_rate_state.dart';

class UpdateRateCubit extends Cubit<UpdateRateState> {
  UpdateRateCubit() : super(UpdateRateInitial());

  static UpdateRateCubit get(context) => BlocProvider.of(context);

  Future<void> updateRate({
    required UpdateRateRequest request,
  }) async {
    emit(UpdateRateLoading());
    try {
      final response = await updateRateFunction(
        request: request,
      );
      emit(
        UpdateRateSuccess(
          message: response["message"]?.toString() ??
              "تم التعديل بنجاح",
        ),
      );
    } catch (e) {

      emit(
        UpdateRateError(
          message: e.toString().replaceFirst(
            "Exception: ",
            "",
          ),
        ),
      );
    }
  }
}