import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/theming/text_styles.dart';
import '../cubit/brand_cubit.dart';
import '../cubit/brand_states.dart';
import '../widgets/brand_dialog.dart';
import '../widgets/model_dialog.dart';


class BrandsAndModelsScreen extends StatelessWidget {
  const BrandsAndModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandsCubit()..getBrands(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<BrandsCubit, BrandsState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              AppSnackBar.showError(state.errorMessage ?? '');
            }
          },
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextInAppWidget(text: AppLanguageKeys.brands, textSize: 18, fontWeightIndex: FontSelectionData.boldFontFamily,),
                              FloatingActionButton.small(
                                backgroundColor: Colors.orange,
                                child: const Icon(Icons.add, color: Colors.white),
                                onPressed: () => showBrandDialog(context),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),

                        if (state.isLoading && state.brands.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(color: Colors.orange),
                          ),

                        Expanded(
                          child: ListView.separated(
                            itemCount: state.brands.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final brand = state.brands[index];
                              final isSelected = state.selectedBrand?.brandId == brand.brandId;

                              return ListTile(
                                title: Text(brand.getLocalizedName(Localizations.localeOf(context).languageCode)),
                                subtitle: Text(brand.getLocalizedSubName(Localizations.localeOf(context).languageCode)),
                                selected: isSelected,
                                selectedTileColor: Colors.orange.withValues(alpha: 0.1),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(Icons.directions_car, color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
                                  onPressed: () => showBrandDialog(context, brandToEdit: brand),
                                ),
                                onTap: () {
                                  context.read<BrandsCubit>().selectBrand(brand);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: state.selectedBrand == null
                        ? const Center(
                      child: TextInAppWidget(text: AppLanguageKeys.pleaseSelectBrandToViewModels, textSize: 16, textColor: Colors.grey,),
                    )
                        : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
                                  const TextInAppWidget(text: AppLanguageKeys.models, textSize: 18, fontWeightIndex: FontSelectionData.boldFontFamily,),
                                  TextInAppWidget(text: '(${state.selectedBrand!.getLocalizedName(Localizations.localeOf(context).languageCode)})', textSize: 18, fontWeightIndex: FontSelectionData.boldFontFamily,),
                                ],
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const TextInAppWidget(text: AppLanguageKeys.addModel, textColor: Colors.white, textSize: 16,),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => showModelDialog(context, state.selectedBrand!.brandId),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),

                        if (state.isModelsLoading)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(color: Colors.orange),
                          )
                        else if (state.models.isEmpty)
                          const Expanded(
                            child: Center(
                              child: TextInAppWidget(text: AppLanguageKeys.noModelsForThisBrandCurrently, textSize: 16, textColor: Colors.grey,),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.separated(
                              itemCount: state.models.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final carModel = state.models[index];
                                return ListTile(
                                  title: Text(carModel.modelName),
                                  leading: const Icon(Icons.directions_car_filled, color: Colors.blueGrey),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
                                    onPressed: () => showModelDialog(context, state.selectedBrand!.brandId, modelToEdit: carModel),
                                  ),
                                );
                              },
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