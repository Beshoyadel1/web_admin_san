import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/datasource/get_car_brand_models_datasource/get_car_brand_repository.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/car_brand_cubit/car_brand_state.dart';

class CarBrandCubit extends Cubit<CarBrandState> {
  CarBrandCubit() : super(CarBrandInitial());

  Future<void> fetchBrands() async {
    emit(CarBrandLoading());

    try {
      final brands = await getCarBrandFunction();

      emit(CarBrandSuccess(brands));
    } catch (e) {
      emit(CarBrandError(e.toString()));
    }
  }
}
