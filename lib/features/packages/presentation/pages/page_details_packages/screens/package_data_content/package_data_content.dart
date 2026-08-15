import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

import '../../../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

import '../../../../../../../features/packages/data/model/get_packages_model/get_packages_model.dart';

import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_cubit.dart';
import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_state.dart';

class PackageDataView extends StatefulWidget {
  final int packageId;

  const PackageDataView({
    required this.packageId,
  });

  @override
  State<PackageDataView> createState() => PackageDataViewState();
}

class PackageDataViewState extends State<PackageDataView> {
  final packageIdController = TextEditingController();

  final packageNameController = TextEditingController();

  final packageLatinNameController = TextEditingController();

  final annualPriceController = TextEditingController();

  final monthPriceController = TextEditingController();

  final packageDiscController = TextEditingController();

  final packageLatinDiscController = TextEditingController();

  bool isEditMode = false;

  @override
  void dispose() {
    packageIdController.dispose();
    packageNameController.dispose();
    packageLatinNameController.dispose();
    annualPriceController.dispose();
    monthPriceController.dispose();
    packageDiscController.dispose();
    packageLatinDiscController.dispose();

    super.dispose();
  }

  // ===================================================
  // FILL DATA
  // ===================================================

  void _fillData(
    PackageModel package,
  ) {
    packageIdController.text = package.packageid?.toString() ?? '';

    packageNameController.text = package.packagename ?? '';

    packageLatinNameController.text = package.packagelatinname ?? '';

    annualPriceController.text = package.annualprice?.toString() ?? '';

    monthPriceController.text = package.monthprice?.toString() ?? '';

    packageDiscController.text = package.packagedisc ?? '';

    packageLatinDiscController.text = package.packagelatindisc ?? '';
  }

  // ===================================================
  // BUILD
  // ===================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return RefreshIndicator(
      color: AppColors.orangeColor,
      onRefresh: () async {
        await context.read<PackagesCubit>().getPackageById(
              packageId: widget.packageId,
            );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocConsumer<PackagesCubit, PackagesState>(
          listener: (
            context,
            state,
          ) {
            if (state is PackageGetByIdSuccess) {
              _fillData(
                state.package,
              );
            }

            if (state is PackagesUpdateSuccess) {
              AppSnackBar.showSuccess(
                AppLanguageKeys.success,
              );

              // // true = package was updated
              // Navigator.pop(
              //   context,
              //   true,
              // );
            }

            // =========================================
            // DELETE SUCCESS
            // =========================================

            if (state is PackagesDeleteSuccess) {
              AppSnackBar.showSuccess(
                state.message,
              );
              Navigator.pop(
                context,
                true,
              );
            }
          },
          builder: (
            context,
            state,
          ) {
            // =========================================
            // LOADING
            // =========================================

            if (state is PackagesLoading) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }


            if (state is PackagesFailure) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: TextInAppWidget(
                    text: state.message,
                    textSize: 15,
                    textColor: AppColors.greyColor,
                    isTextCenter: true,
                  ),
                ),
              );
            }

            // =========================================
            // GET DATA
            // =========================================

            if (state is PackageGetByIdSuccess) {
              final package = state.package;

              if (packageIdController.text.isEmpty) {
                _fillData(
                  package,
                );
              }

              return _buildContent(
                context,
                package,
              );
            }

            // =========================================
            // UPDATE DATA
            // =========================================

            if (state is PackagesUpdateSuccess) {
              return _buildContent(
                context,
                state.package,
              );
            }

            return const SizedBox(
              height: 300,
            );
          },
        ),
      ),
    );
  }

  // ===================================================
  // CONTENT
  // ===================================================

  Widget _buildContent(
    BuildContext context,
    PackageModel package,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),

        // ============================================
        // PACKAGE INFORMATION
        // ============================================

        const TextInAppWidget(
          text: AppLanguageKeys.packageName,
          textSize: 15,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.orangeColor,
        ),

        const SizedBox(
          height: 15,
        ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [

            UserTextFieldWidget(
              controller: packageIdController,
              text: AppLanguageKeys.identity,
              readOnly: true,
              width: 250,
            ),

            // ========================================
            // ARABIC NAME
            // ========================================

            UserTextFieldWidget(
              controller: packageNameController,
              text: AppLanguageKeys.packageName,
              readOnly: !isEditMode,
              width: 250,
            ),

            // ========================================
            // ENGLISH NAME
            // ========================================

            UserTextFieldWidget(
              controller: packageLatinNameController,
              text: AppLanguageKeys.packageLatinName,
              readOnly: !isEditMode,
              width: 250,
            ),

            // ========================================
            // ANNUAL PRICE
            // ========================================

            UserTextFieldWidget(
              controller: annualPriceController,
              text: AppLanguageKeys.annualPrice,
              readOnly: !isEditMode,
              width: 250,
            ),

            // ========================================
            // MONTH PRICE
            // ========================================

            UserTextFieldWidget(
              controller: monthPriceController,
              text: AppLanguageKeys.monthlyPrice,
              readOnly: !isEditMode,
              width: 250,
            ),
          ],
        ),

        const SizedBox(
          height: 25,
        ),


        const TextInAppWidget(
          text: AppLanguageKeys.description,
          textSize: 15,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.orangeColor,

        ),

        const SizedBox(
          height: 15,
        ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // ========================================
            // ARABIC DESCRIPTION
            // ========================================

            UserTextFieldWidget(
              controller: packageDiscController,
              text: AppLanguageKeys.packageDescription,
              readOnly: !isEditMode,
              width: 350,
              maxLines:5,
            ),

            // ========================================
            // ENGLISH DESCRIPTION
            // ========================================

            UserTextFieldWidget(
              controller: packageLatinDiscController,
              text: AppLanguageKeys.packageLatinDisc,
              readOnly: !isEditMode,
              width: 350,
              maxLines:5,
            ),
          ],
        ),

        const SizedBox(
          height: 30,
        ),

        _buildActions(
          context,
          package,
        ),
      ],
    );
  }

  // ===================================================
  // ACTIONS
  // ===================================================

  Widget _buildActions(
    BuildContext context,
    PackageModel package,
  ) {
    return BlocBuilder<PackagesCubit, PackagesState>(
      builder: (
        context,
        state,
      ) {
        final isLoading = state is PackagesLoading;

        return Row(
          children: [
            // ========================================
            // EDIT / SAVE
            // ========================================

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      if (!isEditMode) {
                        setState(() {
                          isEditMode = true;
                        });
                      } else {
                        _updatePackage(
                          package,
                        );
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : TextInAppWidget(
                      text: isEditMode
                          ? AppLanguageKeys.save
                          : AppLanguageKeys.edit,
                      textSize: 13,
                      textColor: AppColors.whiteColor,
                    ),
            ),

            const SizedBox(
              width: 10,
            ),

            // ========================================
            // CANCEL
            // ========================================

            if (isEditMode)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greyColor,
                ),
                onPressed: () {
                  _fillData(
                    package,
                  );

                  setState(() {
                    isEditMode = false;
                  });
                },
                child: const TextInAppWidget(
                  text: AppLanguageKeys.cancel,
                  textSize: 13,
                  textColor: AppColors.whiteColor,
                ),
              ),

            // ========================================
            // DELETE
            // ========================================

            if (!isEditMode) ...[
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        _deletePackage(
                          package.packageid,
                        );
                      },
                child: const TextInAppWidget(
                  text: AppLanguageKeys.delete,
                  textSize: 13,
                  textColor: AppColors.whiteColor,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // ===================================================
  // UPDATE
  // ===================================================

  void _updatePackage(
    PackageModel oldPackage,
  ) {
    final packageId = oldPackage.packageid;

    if (packageId == null) {
      AppSnackBar.showError(
        'Package ID is not available',
      );
      return;
    }

    context.read<PackagesCubit>().updatePackage(
          packageModel: PackageModel(
            packageid: packageId,
            packagename: packageNameController.text.trim(),
            packagelatinname: packageLatinNameController.text.trim(),
            annualprice: double.tryParse(
                  annualPriceController.text.trim(),
                ) ??
                0,
            monthprice: double.tryParse(
                  monthPriceController.text.trim(),
                ) ??
                0,
            packagedisc: packageDiscController.text.trim(),
            packagelatindisc: packageLatinDiscController.text.trim(),
          ),
        );
  }

  // ===================================================
  // DELETE
  // ===================================================

  void _deletePackage(
    int? packageId,
  ) {
    if (packageId == null) {
      AppSnackBar.showError(
        'Package ID is not available',
      );
      return;
    }

    context.read<PackagesCubit>().deletePackage(
          packageId: packageId,
        );
  }
}
