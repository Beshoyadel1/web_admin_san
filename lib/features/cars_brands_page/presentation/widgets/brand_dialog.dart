import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/language/language_constant.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/theming/text_styles.dart';
import '../../data/Models/brand_model.dart';
import '../cubit/brand_cubit.dart';

void showBrandDialog(BuildContext parentContext, {BrandModel? brandToEdit}) {
  final isEdit = brandToEdit != null;
  final nameArController = TextEditingController(text: isEdit ? brandToEdit.brandName : '');
  final nameEnController = TextEditingController(text: isEdit ? brandToEdit.brandLatinName : '');

  final brandsCubit = parentContext.read<BrandsCubit>();

  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return AlertDialog(
        title: TextInAppWidget(
          text: isEdit ? AppLanguageKeys.editBrandDetails : AppLanguageKeys.addNewBrand,
          textSize: 18,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameArController,
                decoration: const InputDecoration(
                  label: TextInAppWidget(text: AppLanguageKeys.arabicNameExample, textColor: Colors.grey, textSize: 16,),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameEnController,
                decoration: const InputDecoration(
                  label: TextInAppWidget(text: AppLanguageKeys.englishNameExample, textColor: Colors.grey, textSize: 16,),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const TextInAppWidget(text: AppLanguageKeys.cancel, textColor: Colors.grey, textSize: 16),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              if (nameArController.text.isEmpty || nameEnController.text.isEmpty) {
                return;
              }

              if (isEdit) {
                final updatedBrand = BrandModel(
                  brandId: brandToEdit.brandId,
                  brandName: nameArController.text,
                  brandLatinName: nameEnController.text,
                  image: brandToEdit.image,
                );
                brandsCubit.updateBrand(updatedBrand);
              } else {
                brandsCubit.createBrand(
                  nameArController.text,
                  nameEnController.text,
                  null,
                );
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