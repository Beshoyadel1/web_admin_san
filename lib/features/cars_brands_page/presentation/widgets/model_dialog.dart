import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/language/language_constant.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/theming/text_styles.dart';
import '../../data/Models/car_model.dart';
import '../cubit/brand_cubit.dart';

void showModelDialog(BuildContext parentContext, int brandId, {CarsBrandModel? modelToEdit}) {
  final isEdit = modelToEdit != null;
  final nameController = TextEditingController(text: isEdit ? modelToEdit.modelName : '');
  final brandsCubit = parentContext.read<BrandsCubit>();

  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return AlertDialog(
        title: TextInAppWidget(
          text: isEdit ? AppLanguageKeys.editModel : AppLanguageKeys.addNewModel,
          textSize: 18,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              label: TextInAppWidget(text: AppLanguageKeys.modelNameExample, textColor: Colors.grey, textSize: 16,),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const TextInAppWidget(text: AppLanguageKeys.cancel, textColor: Colors.grey,textSize: 16,),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              if (nameController.text.isEmpty) return;

              if (isEdit) {
                final updatedModel = CarsBrandModel(
                  modelId: modelToEdit.modelId,
                  modelName: nameController.text,
                  carBrandId: brandId,
                  image: modelToEdit.image,
                );
                brandsCubit.updateModel(updatedModel);
              } else {
                brandsCubit.createModel(nameController.text, brandId, null);
              }
              Navigator.pop(dialogContext);
            },
            child: TextInAppWidget(
              text: isEdit ? AppLanguageKeys.saveChanges : AppLanguageKeys.add,
              textColor: Colors.white,
              textSize: 16,
            ),
          ),
        ],
      );
    },
  );
}