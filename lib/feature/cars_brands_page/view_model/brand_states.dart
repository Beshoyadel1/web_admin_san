import '../data/Models/brand_model.dart';
import '../data/Models/car_model.dart';

class BrandsState {
  final bool isLoading;
  final bool isModelsLoading;
  final bool isActionLoading;
  final List<BrandModel> brands;
  final BrandModel? selectedBrand;
  final List<CarsBrandModel> models;
  final String? errorMessage;
  final String brandSearchQuery;
  final String modelSearchQuery;

  BrandsState({
    this.isLoading = false,
    this.isModelsLoading = false,
    this.isActionLoading = false,
    this.brands = const [],
    this.selectedBrand,
    this.models = const [],
    this.errorMessage,
    this.brandSearchQuery = '',
    this.modelSearchQuery = '',
  });

  List<BrandModel> get filteredBrands {
    if (brandSearchQuery.trim().isEmpty) return brands;
    final query = brandSearchQuery.trim().toLowerCase();
    return brands.where((b) {
      final arMatch = b.brandName.toLowerCase().contains(query);
      final enMatch = b.brandLatinName.toLowerCase().contains(query);
      return arMatch || enMatch;
    }).toList();
  }

  List<CarsBrandModel> get filteredModels {
    if (modelSearchQuery.trim().isEmpty) return models;
    final query = modelSearchQuery.trim().toLowerCase();
    return models.where((m) {
      return m.modelName.toLowerCase().contains(query);
    }).toList();
  }

  BrandsState copyWith({
    bool? isLoading,
    bool? isModelsLoading,
    bool? isActionLoading,
    List<BrandModel>? brands,
    BrandModel? selectedBrand,
    List<CarsBrandModel>? models,
    String? errorMessage,
    String? brandSearchQuery,
    String? modelSearchQuery,
    bool clearSelectedBrand = false,
  }) {
    return BrandsState(
      isLoading: isLoading ?? this.isLoading,
      isModelsLoading: isModelsLoading ?? this.isModelsLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      brands: brands ?? this.brands,
      selectedBrand:
          clearSelectedBrand ? null : (selectedBrand ?? this.selectedBrand),
      models: models ?? this.models,
      errorMessage: errorMessage,
      brandSearchQuery: brandSearchQuery ?? this.brandSearchQuery,
      modelSearchQuery: modelSearchQuery ?? this.modelSearchQuery,
    );
  }
}
