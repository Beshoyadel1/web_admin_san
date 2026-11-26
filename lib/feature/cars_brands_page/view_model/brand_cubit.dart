import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_link.dart';
import '../../../../core/networking/network.dart';
import '../data/Models/brand_model.dart';
import '../data/Models/car_model.dart';
import 'brand_states.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit() : super(BrandsState());

  // ================= البحث والفلترة =================

  void setBrandSearchQuery(String query) {
    if (isClosed) return;
    emit(state.copyWith(brandSearchQuery: query));
  }

  void setModelSearchQuery(String query) {
    if (isClosed) return;
    emit(state.copyWith(modelSearchQuery: query));
  }

  // ================= الماركات (Brands) =================

  Future<void> getBrands() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await Network.getData(ApiLink.getCarBrands);

      if (isClosed) return;

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        final List<BrandModel> brandsList =
            data.map((json) => BrandModel.fromJson(json)).toList();

        // If previously selected brand exists, refresh its reference
        BrandModel? refreshedSelectedBrand;
        if (state.selectedBrand != null) {
          final found = brandsList
              .where((b) => b.brandId == state.selectedBrand!.brandId);
          if (found.isNotEmpty) {
            refreshedSelectedBrand = found.first;
          }
        }

        emit(state.copyWith(
          isLoading: false,
          brands: brandsList,
          selectedBrand: refreshedSelectedBrand,
        ));
      } else {
        emit(state.copyWith(
            isLoading: false,
            errorMessage: LocaleKeys.errorFetchingBrands.tr()));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createBrand(
      String nameAr, String nameEn, String? imageBase64) async {
    if (isClosed) return;
    emit(state.copyWith(isActionLoading: true));
    try {
      final newBrand = BrandModel(
        brandId: 0,
        brandName: nameAr,
        brandLatinName: nameEn,
        image: imageBase64,
      );
      final response = await Network.postDataWithBody(
        newBrand.toJson(isUpdate: false),
        ApiLink.createCarBrand,
      );

      if (isClosed) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isActionLoading: false));
        await getBrands();
      } else {
        emit(state.copyWith(
            isActionLoading: false,
            errorMessage: LocaleKeys.failedToAddBrand.tr()));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateBrand(BrandModel brandToUpdate) async {
    if (isClosed) return;
    emit(state.copyWith(isActionLoading: true));
    try {
      final response = await Network.postDataWithBody(
        brandToUpdate.toJson(isUpdate: true),
        ApiLink.updateCarBrand,
      );

      if (isClosed) return;

      if (response.statusCode == 200) {
        emit(state.copyWith(
          isActionLoading: false,
          selectedBrand: state.selectedBrand?.brandId == brandToUpdate.brandId
              ? brandToUpdate
              : state.selectedBrand,
        ));
        await getBrands();
      } else {
        emit(state.copyWith(
            isActionLoading: false,
            errorMessage: LocaleKeys.failedToUpdateBrand.tr()));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }

  // ================= الموديلات (Models) =================

  void selectBrand(BrandModel brand) {
    if (isClosed) return;
    emit(state.copyWith(selectedBrand: brand, modelSearchQuery: ''));
    getModelsByBrandId(brand.brandId);
  }

  Future<void> getModelsByBrandId(int brandId) async {
    if (isClosed) return;
    emit(state.copyWith(isModelsLoading: true, errorMessage: null));
    try {
      final response = await Network.postDataWithQuery(
        {'carBrandId': brandId},
        ApiLink.getCarBrandModels,
      );

      if (isClosed) return;

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        final List<CarsBrandModel> modelsList =
            data.map((json) => CarsBrandModel.fromJson(json)).toList();

        emit(state.copyWith(isModelsLoading: false, models: modelsList));
      } else {
        emit(state.copyWith(
            isModelsLoading: false,
            errorMessage: LocaleKeys.errorFetchingModels.tr()));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isModelsLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> createModel(
      String modelName, int brandId, String? imageBase64) async {
    if (isClosed) return;
    emit(state.copyWith(isActionLoading: true));
    try {
      final newModel = CarsBrandModel(
        modelId: 0,
        modelName: modelName,
        carBrandId: brandId,
        image: imageBase64,
      );
      final response = await Network.postDataWithBody(
        newModel.toJson(isUpdate: false),
        ApiLink.createCarModel,
      );

      if (isClosed) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(isActionLoading: false));
        await getModelsByBrandId(brandId);
      } else {
        emit(state.copyWith(
            isActionLoading: false,
            errorMessage: LocaleKeys.failedToAddModel.tr()));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateModel(CarsBrandModel modelToUpdate) async {
    if (isClosed) return;
    emit(state.copyWith(isActionLoading: true));
    try {
      final response = await Network.postDataWithBody(
        modelToUpdate.toJson(isUpdate: true),
        ApiLink.updateCarModel,
      );

      if (isClosed) return;

      if (response.statusCode == 200) {
        emit(state.copyWith(isActionLoading: false));
        await getModelsByBrandId(modelToUpdate.carBrandId);
      } else {
        emit(state.copyWith(
            isActionLoading: false,
            errorMessage: LocaleKeys.failedToUpdateModel.tr()));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isActionLoading: false, errorMessage: e.toString()));
    }
  }
}
