import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/dio_function/api_constants.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../data/Models/brand_model.dart';
import '../../data/Models/car_model.dart';
import 'brand_states.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit() : super(BrandsState());

  // ================= الماركات (Brands) =================

  Future<void> getBrands() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await Network.getData(ApiLink.getCarBrands);

      if (response.data['success'] == true) {
        List<dynamic> data = response.data['data'];
        List<BrandModel> brandsList = data.map((json) => BrandModel.fromJson(json)).toList();

        emit(state.copyWith(isLoading: false, brands: brandsList));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'حدث خطأ في جلب البيانات'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createBrand(String nameAr, String nameEn, String? imageBase64) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final newBrand = BrandModel(brandId: 0, brandName: nameAr, brandLatinName: nameEn, image: imageBase64);
      final response = await Network.postDataWithBody(newBrand.toJson(isUpdate: false), ApiLink.createCarBrand);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isActionLoading: false));
        getBrands();
      }
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateBrand(BrandModel brandToUpdate) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final response = await Network.postDataWithBody(brandToUpdate.toJson(isUpdate: true), ApiLink.updateCarBrand);

      if (response.statusCode == 200) {
        emit(state.copyWith(isActionLoading: false));
        getBrands();
      }
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }

  // ================= الموديلات (Models) =================

  void selectBrand(BrandModel brand) {
    emit(state.copyWith(selectedBrand: brand));
    getModelsByBrandId(brand.brandId);
  }

  Future<void> getModelsByBrandId(int brandId) async {
    emit(state.copyWith(isModelsLoading: true, errorMessage: null));
    try {

      final response = await Network.postDataWithQuery(
        {'carBrandId': brandId},
        ApiLink.getCarBrandModels,
      );

      if (response.data['success'] == true) {
        List<dynamic> data = response.data['data'];
        List<CarsBrandModel> modelsList = data.map((json) => CarsBrandModel.fromJson(json)).toList();

        emit(state.copyWith(isModelsLoading: false, models: modelsList));
      } else {
        emit(state.copyWith(isModelsLoading: false, errorMessage: 'حدث خطأ في جلب الموديلات'));
      }
    } catch (e) {
      emit(state.copyWith(isModelsLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createModel(String modelName, int brandId, String? imageBase64) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final newModel = CarsBrandModel(modelId: 0, modelName: modelName, carBrandId: brandId, image: imageBase64);
      final response = await Network.postDataWithBody(newModel.toJson(isUpdate: false), ApiLink.createCarModel);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isActionLoading: false));
        getModelsByBrandId(brandId);
      }
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateModel(CarsBrandModel modelToUpdate) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      final response = await Network.postDataWithBody(modelToUpdate.toJson(isUpdate: true), ApiLink.updateCarModel);

      if (response.statusCode == 200) {
        emit(state.copyWith(isActionLoading: false));
        getModelsByBrandId(modelToUpdate.carBrandId);
      }
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }
}