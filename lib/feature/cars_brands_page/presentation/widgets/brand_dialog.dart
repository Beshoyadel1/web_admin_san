import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/helpers/themes/fonts.dart';
import '../../../../core/helpers/themes/text_styles.dart';
import '../../data/Models/brand_model.dart';
import '../../view_model/brand_cubit.dart';
import 'brand_image_picker_widget.dart';

void showBrandDialog(BuildContext parentContext, {BrandModel? brandToEdit}) {
  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return BrandDialogWidget(
        brandToEdit: brandToEdit,
        parentContext: parentContext,
      );
    },
  );
}

class BrandDialogWidget extends StatefulWidget {
  final BrandModel? brandToEdit;
  final BuildContext parentContext;

  const BrandDialogWidget({
    super.key,
    this.brandToEdit,
    required this.parentContext,
  });

  @override
  State<BrandDialogWidget> createState() => _BrandDialogWidgetState();
}

class _BrandDialogWidgetState extends State<BrandDialogWidget> {
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late String? _imageBase64;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(
      text: widget.brandToEdit?.brandName ?? '',
    );
    _nameEnController = TextEditingController(
      text: widget.brandToEdit?.brandLatinName ?? '',
    );
    _imageBase64 = widget.brandToEdit?.image;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = widget.parentContext.read<BrandsCubit>();
    final isEdit = widget.brandToEdit != null;

    if (isEdit) {
      final updatedBrand = BrandModel(
        brandId: widget.brandToEdit!.brandId,
        brandName: _nameArController.text.trim(),
        brandLatinName: _nameEnController.text.trim(),
        image: _imageBase64,
      );
      cubit.updateBrand(updatedBrand);
    } else {
      cubit.createBrand(
        _nameArController.text.trim(),
        _nameEnController.text.trim(),
        _imageBase64,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.brandToEdit != null;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.whiteColor,
      title: TextInAppWidget(
        text: isEdit ? LocaleKeys.editBrandDetails : LocaleKeys.addNewBrand,
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
                  initialImageBytes: widget.brandToEdit?.imageBytes,
                  onImageChanged: (newBase64) {
                    _imageBase64 = newBase64;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameArController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return LocaleKeys.pleaseEnterArabicName.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleKeys.arabicNameLabel.tr(),
                    labelStyle: const TextStyle(
                      color: AppColors.darkGreyColor,
                      fontSize: 14,
                    ),
                    hintText: LocaleKeys.exampleToyota.tr(),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameEnController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return LocaleKeys.pleaseEnterEnglishName.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleKeys.englishNameLabel.tr(),
                    labelStyle: const TextStyle(
                      color: AppColors.darkGreyColor,
                      fontSize: 14,
                    ),
                    hintText: 'e.g. Toyota',
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
