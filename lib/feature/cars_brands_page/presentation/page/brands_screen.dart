import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../core/helpers/colors/app_colors.dart';
import '../../view_model/brand_cubit.dart';
import '../../view_model/brand_states.dart';
import '../widgets/brand_card_item.dart';
import '../widgets/brand_dialog.dart';
import '../widgets/brand_empty_view.dart';
import '../widgets/brand_search_field.dart';
import '../widgets/brands_panel_header.dart';
import '../widgets/model_card_item.dart';
import '../widgets/model_dialog.dart';
import '../widgets/models_panel_header.dart';

class CarsBrandsPage extends StatefulWidget {
  const CarsBrandsPage({super.key});

  @override
  State<CarsBrandsPage> createState() => _CarsBrandsPageState();
}

class _CarsBrandsPageState extends State<CarsBrandsPage> {
  final ScrollController _brandsScrollController = ScrollController();
  final ScrollController _modelsScrollController = ScrollController();

  @override
  void dispose() {
    _brandsScrollController.dispose();
    _modelsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandsCubit()..getBrands(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<BrandsCubit, BrandsState>(
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              AppSnackBar.showError(state.errorMessage!);
            }
          },
          builder: (context, state) {
            final cubit = context.read<BrandsCubit>();
            final filteredBrands = state.filteredBrands;
            final filteredModels = state.filteredModels;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================== عمود الماركات (Left Panel) ==================
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.cardStroke,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkColor.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        BrandsPanelHeader(
                          totalCount: state.brands.length,
                          onAddBrand: () => showBrandDialog(context),
                        ),
                        const Divider(height: 1, color: AppColors.cardStroke),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 10.0,
                          ),
                          child: BrandSearchField(
                            hintText: LocaleKeys.searchBrandHint.tr(),
                            onChanged: (q) => cubit.setBrandSearchQuery(q),
                            onClear: () => cubit.setBrandSearchQuery(''),
                          ),
                        ),
                        Expanded(
                          child: state.isLoading && state.brands.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.orangeColor,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : filteredBrands.isEmpty
                                  ? BrandEmptyView(
                                      icon: Icons.directions_car_outlined,
                                      message: state.brandSearchQuery.isNotEmpty
                                          ? LocaleKeys.noMatchingBrandsFound
                                              .tr()
                                          : LocaleKeys.noBrandsRegisteredYet
                                              .tr(),
                                      onRetry: state.brands.isEmpty
                                          ? () => cubit.getBrands()
                                          : null,
                                    )
                                  : Scrollbar(
                                      thumbVisibility: true,
                                      controller: _brandsScrollController,
                                      child: ListView.builder(
                                        controller: _brandsScrollController,
                                        itemCount: filteredBrands.length,
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        itemBuilder: (context, index) {
                                          final brand = filteredBrands[index];
                                          final isSelected =
                                              state.selectedBrand?.brandId ==
                                                  brand.brandId;

                                          return BrandCardItem(
                                            brand: brand,
                                            isSelected: isSelected,
                                            onTap: () =>
                                                cubit.selectBrand(brand),
                                            onEdit: () => showBrandDialog(
                                              context,
                                              brandToEdit: brand,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // ================== عمود الموديلات (Right Panel) ==================
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.cardStroke,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkColor.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: state.selectedBrand == null
                        ? BrandEmptyView(
                            icon: Icons.touch_app_outlined,
                            message:
                                LocaleKeys.pleaseSelectBrandToViewModels.tr(),
                            subMessage:
                                LocaleKeys.clickBrandToViewItsModels.tr(),
                          )
                        : Column(
                            children: [
                              ModelsPanelHeader(
                                brandName: state.selectedBrand!
                                    .getLocalizedName(
                                        context.locale.languageCode),
                                totalCount: state.models.length,
                                onAddModel: () => showModelDialog(
                                  context,
                                  state.selectedBrand!.brandId,
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: AppColors.cardStroke,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 10.0,
                                ),
                                child: BrandSearchField(
                                  hintText:
                                      LocaleKeys.searchBrandModelsPrompt.tr(
                                    args: [
                                      state.selectedBrand!.getLocalizedName(
                                          context.locale.languageCode)
                                    ],
                                  ),
                                  onChanged: (q) =>
                                      cubit.setModelSearchQuery(q),
                                  onClear: () => cubit.setModelSearchQuery(''),
                                ),
                              ),
                              Expanded(
                                child: state.isModelsLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.orangeColor,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : filteredModels.isEmpty
                                        ? BrandEmptyView(
                                            icon: Icons
                                                .directions_car_filled_outlined,
                                            message: state
                                                    .modelSearchQuery.isNotEmpty
                                                ? LocaleKeys
                                                    .noMatchingModelsFound
                                                    .tr()
                                                : LocaleKeys
                                                    .noModelsForThisBrand
                                                    .tr(),
                                            onRetry: state.models.isEmpty
                                                ? () =>
                                                    cubit.getModelsByBrandId(
                                                      state.selectedBrand!
                                                          .brandId,
                                                    )
                                                : null,
                                          )
                                        : Scrollbar(
                                            thumbVisibility: true,
                                            controller: _modelsScrollController,
                                            child: ListView.builder(
                                              controller:
                                                  _modelsScrollController,
                                              itemCount: filteredModels.length,
                                              padding: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              itemBuilder: (context, index) {
                                                final carModel =
                                                    filteredModels[index];
                                                return ModelCardItem(
                                                  carModel: carModel,
                                                  onEdit: () => showModelDialog(
                                                    context,
                                                    state
                                                        .selectedBrand!.brandId,
                                                    modelToEdit: carModel,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
