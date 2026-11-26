import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_form_field.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_cubit.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_state.dart';

class CreatePackageDialog extends StatefulWidget {
  const CreatePackageDialog({super.key});

  @override
  State<CreatePackageDialog> createState() => _CreatePackageDialogState();
}

class _CreatePackageDialogState extends State<CreatePackageDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _packageNameController;
  late final TextEditingController _packageLatinNameController;
  late final TextEditingController _annualPriceController;
  late final TextEditingController _monthPriceController;
  late final TextEditingController _packageDiscController;
  late final TextEditingController _packageLatinDiscController;

  @override
  void initState() {
    super.initState();
    _packageNameController = TextEditingController();
    _packageLatinNameController = TextEditingController();
    _annualPriceController = TextEditingController();
    _monthPriceController = TextEditingController();
    _packageDiscController = TextEditingController();
    _packageLatinDiscController = TextEditingController();
  }

  @override
  void dispose() {
    _packageNameController.dispose();
    _packageLatinNameController.dispose();
    _annualPriceController.dispose();
    _monthPriceController.dispose();
    _packageDiscController.dispose();
    _packageLatinDiscController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newPackage = PackageModel(
      packagename: _packageNameController.text.trim(),
      packagelatinname: _packageLatinNameController.text.trim(),
      annualprice: double.tryParse(_annualPriceController.text.trim()) ?? 0,
      monthprice: double.tryParse(_monthPriceController.text.trim()) ?? 0,
      packagedisc: _packageDiscController.text.trim(),
      packagelatindisc: _packageLatinDiscController.text.trim(),
    );

    context.read<PackagesCubit>().createPackage(
          packageModel: newPackage,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PackagesCubit, PackagesState>(
      listener: (context, state) {
        if (state is PackagesCreateSuccess) {
          AppSnackBar.showSuccess(
            LocaleKeys.success.tr(),
          );
          Navigator.pop(context, true);
        } else if (state is PackagesFailure) {
          AppSnackBar.showError(
            state.message,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PackagesLoading;

        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInAppWidget(
                text: LocaleKeys.create.tr(),
                textSize: 18,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.orangeColor,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.greyColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PackageFormField(
                      title: LocaleKeys.packageName,
                      controller: _packageNameController,
                    ),
                    const SizedBox(height: 14),
                    PackageFormField(
                      title: LocaleKeys.packageLatinName,
                      controller: _packageLatinNameController,
                    ),
                    const SizedBox(height: 14),
                    PackageFormField(
                      title: LocaleKeys.monthlyPrice,
                      controller: _monthPriceController,
                      isDigitDot: true,
                    ),
                    const SizedBox(height: 14),
                    PackageFormField(
                      title: LocaleKeys.annualPrice,
                      controller: _annualPriceController,
                      isDigitDot: true,
                    ),
                    const SizedBox(height: 14),
                    PackageFormField(
                      title: LocaleKeys.packageDescription,
                      controller: _packageDiscController,
                      maxLines: 3,
                      textFormHeight: 80,
                    ),
                    const SizedBox(height: 14),
                    PackageFormField(
                      title: LocaleKeys.packageLatinDisc,
                      controller: _packageLatinDiscController,
                      maxLines: 3,
                      textFormHeight: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 16,
            top: 8,
          ),
          actions: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: TextInAppWidget(
                  text: LocaleKeys.cancel.tr(),
                  textSize: 14,
                  textColor: AppColors.greyColor,
                ),
              ),
            ),
            MouseRegion(
              cursor: isLoading
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  disabledBackgroundColor:
                      AppColors.orangeColor.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : TextInAppWidget(
                        text: LocaleKeys.create.tr(),
                        textSize: 14,
                        textColor: AppColors.whiteColor,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
