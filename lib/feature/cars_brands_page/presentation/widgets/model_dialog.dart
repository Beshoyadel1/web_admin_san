import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/helpers/themes/fonts.dart';
import '../../../../core/helpers/themes/text_styles.dart';
import '../../data/Models/car_model.dart';
import '../../view_model/brand_cubit.dart';
import 'brand_image_picker_widget.dart';

void showModelDialog(
  BuildContext parentContext,
  int brandId, {
  CarsBrandModel? modelToEdit,
}) {
  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return ModelDialogWidget(
        brandId: brandId,
        modelToEdit: modelToEdit,
        parentContext: parentContext,
      );
    },
  );
}

class ModelDialogWidget extends StatefulWidget {
  final int brandId;
  final CarsBrandModel? modelToEdit;
  final BuildContext parentContext;

  const ModelDialogWidget({
    super.key,
    required this.brandId,
    this.modelToEdit,
    required this.parentContext,
  });

  @override
  State<ModelDialogWidget> createState() => _ModelDialogWidgetState();
}

class _ModelDialogWidgetState extends State<ModelDialogWidget> {
  late final TextEditingController _nameController;
  late String? _imageBase64;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.modelToEdit?.modelName ?? '',
    );
    _imageBase64 = widget.modelToEdit?.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = widget.parentContext.read<BrandsCubit>();
    final isEdit = widget.modelToEdit != null;

    if (isEdit) {
      final updatedModel = CarsBrandModel(
        modelId: widget.modelToEdit!.modelId,
        modelName: _nameController.text.trim(),
        carBrandId: widget.brandId,
        image: _imageBase64,
      );
      cubit.updateModel(updatedModel);
    } else {
      cubit.createModel(
        _nameController.text.trim(),
        widget.brandId,
        _imageBase64,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.modelToEdit != null;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.whiteColor,
      title: TextInAppWidget(
        text: isEdit ? LocaleKeys.editModel : LocaleKeys.addNewModel,
        textSize: 18,
        textColor: AppColors.darkColor,
        fontWeightIndex: FontSelectionData.boldFontFamily,
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                BrandImagePickerWidget(
                  initialImageBytes: widget.modelToEdit?.imageBytes,
                  onImageChanged: (newBase64) {
                    _imageBase64 = newBase64;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return LocaleKeys.pleaseEnterModelName.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleKeys.modelNameLabel.tr(),
                    labelStyle: const TextStyle(
                      color: AppColors.darkGreyColor,
                      fontSize: 14,
                    ),
                    hintText: LocaleKeys.modelNamePlaceholder.tr(),
                    hintStyle: const TextStyle(
                      color: AppColors.lightGreyColor,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: AppColors.scaffoldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.cardStroke),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.cardStroke),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.orangeColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const TextInAppWidget(
            text: LocaleKeys.cancel,
            textColor: AppColors.darkGreyColor,
            textSize: 15,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          onPressed: _handleSubmit,
          child: TextInAppWidget(
            text: isEdit ? LocaleKeys.saveChanges : LocaleKeys.add,
            textColor: AppColors.whiteColor,
            textSize: 15,
            fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          ),
        ),
      ],
    );
  }
}
