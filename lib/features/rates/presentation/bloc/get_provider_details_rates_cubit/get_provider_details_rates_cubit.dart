import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/get_provider_details_rates_datasource/get_provider_details_rates_repository.dart';
import '../../../data/model/get_provider_details_rates_model/get_provider_details_rates_model.dart';
import '../../../data/request/get_provider_details_rates_request/get_provider_details_rates_request.dart';
import 'get_provider_details_rates_state.dart';

class GetProviderDetailsRatesCubit extends Cubit<GetProviderDetailsRatesState> {
  GetProviderDetailsRatesCubit()
      : super(
          GetProviderDetailsRatesInitial(),
        );

  static GetProviderDetailsRatesCubit get(
    context,
  ) =>
      BlocProvider.of(context);

  ProviderDetailsRatesModel? model;

  Future<void> getProviderDetailsRates({
    required int providerId,
    required int serviceId,
  }) async {
    emit(
      GetProviderDetailsRatesLoading(),
    );

    try {
      model = await getProviderDetailsRatesFunction(
        request: GetProviderDetailsRatesRequest(
          providerId: providerId,
          serviceId: serviceId,
        ),
      );

      emit(
        GetProviderDetailsRatesSuccess(
          model!,
        ),
      );
    } catch (e) {
      emit(
        GetProviderDetailsRatesError(
          e.toString(),
        ),
      );
    }
  }
}
