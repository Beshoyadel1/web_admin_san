import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/rates/data/datasource/get_providers_basic_rate_datasource/get_providers_basic_rate_datasource.dart';
import 'providers_rate_state.dart';

class ProvidersRateCubit extends Cubit<ProvidersRateState> {
  ProvidersRateCubit() : super(ProvidersRateInitial());

  List providers = [];

  Future<void> getProvidersRates() async {
    emit(ProvidersRateLoading());

    try {
      final result = await getProvidersBasicRateFunction();

      providers = result;

      emit(
        ProvidersRateSuccess(result),
      );
    } catch (e) {
      emit(
        ProvidersRateError(
          e.toString(),
        ),
      );
    }
  }
}