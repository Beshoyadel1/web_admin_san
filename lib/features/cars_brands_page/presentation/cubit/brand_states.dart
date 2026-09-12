import '../../data/Models/brand_model.dart';
import '../../data/Models/car_model.dart'; // تأكد من المسار

class BrandsState {
  final bool isLoading;
  final bool isModelsLoading; // حالة تحميل الموديلات
  final bool isActionLoading;
  final List<BrandModel> brands;
  final BrandModel? selectedBrand;
  final List<CarsBrandModel> models;
  final String? errorMessage;

  BrandsState({
    this.isLoading = false,
    this.isModelsLoading = false,
    this.isActionLoading = false,
    this.brands = const [],
    this.selectedBrand,
    this.models = const [],
    this.errorMessage,
  });

  BrandsState copyWith({
    bool? isLoading,
    bool? isModelsLoading,
    bool? isActionLoading,
    List<BrandModel>? brands,
    BrandModel? selectedBrand,
    List<CarsBrandModel>? models,
    String? errorMessage,
  }) {
    return BrandsState(
      isLoading: isLoading ?? this.isLoading,
      isModelsLoading: isModelsLoading ?? this.isModelsLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      brands: brands ?? this.brands,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      models: models ?? this.models,
      errorMessage: errorMessage,
    );
  }
}