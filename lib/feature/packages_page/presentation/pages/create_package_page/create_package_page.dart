import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';
import 'package:web_admin_san/feature/packages_page/presentation/widgets/package_form_field.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_cubit.dart';
import 'package:web_admin_san/feature/packages_page/view_model/packages_cubit/packages_state.dart';

class CreatePackagePage extends StatefulWidget {
  const CreatePackagePage({super.key});

  @override
  State<CreatePackagePage> createState() => _CreatePackagePageState();
}

class _CreatePackagePageState extends State<CreatePackagePage> {
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.transparent,
        elevation: 0.5,
        leading: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.darkColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: TextInAppWidget(
          text: LocaleKeys.create.tr(),
          textSize: 18,
          fontWeightIndex: FontSelectionData.boldFontFamily,
          textColor: AppColors.darkColor,
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PackagesCubit, PackagesState>(
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

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: CustomContainer(
                    isSelected: false,
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    containerWidth: double.infinity,
                    typeWidget: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextInAppWidget(
                              text: LocaleKeys.create.tr(),
                              textSize: 16,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                              textColor: AppColors.orangeColor,
                            ),
                            const SizedBox(height: 20),

                            // Arabic Name
                            PackageFormField(
                              title: LocaleKeys.packageName,
                              controller: _packageNameController,
                            ),
                            const SizedBox(height: 16),

                            // English Name
                            PackageFormField(
                              title: LocaleKeys.packageLatinName,
                              controller: _packageLatinNameController,
                            ),
                            const SizedBox(height: 16),

                            // Monthly Price
                            PackageFormField(
                              title: LocaleKeys.monthlyPrice,
                              controller: _monthPriceController,
                              isDigitDot: true,
                            ),
                            const SizedBox(height: 16),

                            // Annual Price
                            PackageFormField(
                              title: LocaleKeys.annualPrice,
                              controller: _annualPriceController,
                              isDigitDot: true,
                            ),
                            const SizedBox(height: 16),

                            // Arabic Description
                            PackageFormField(
                              title: LocaleKeys.packageDescription,
                              controller: _packageDiscController,
                              maxLines: 4,
                              textFormHeight: 90,
                            ),
                            const SizedBox(height: 16),

                            // English Description
                            PackageFormField(
                              title: LocaleKeys.packageLatinDisc,
                              controller: _packageLatinDiscController,
                              maxLines: 4,
                              textFormHeight: 90,
                            ),
                            const SizedBox(height: 28),

                            // Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => Navigator.pop(context),
                                    child: TextInAppWidget(
                                      text: LocaleKeys.cancel.tr(),
                                      textSize: 14,
                                      textColor: AppColors.greyColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                MouseRegion(
                                  cursor: isLoading
                                      ? SystemMouseCursors.basic
                                      : SystemMouseCursors.click,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.orangeColor,
                                      disabledBackgroundColor: AppColors
                                          .orangeColor
                                          .withValues(alpha: 0.6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
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
                                            fontWeightIndex: FontSelectionData
                                                .mediumFontFamily,
                                            textColor: AppColors.whiteColor,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
