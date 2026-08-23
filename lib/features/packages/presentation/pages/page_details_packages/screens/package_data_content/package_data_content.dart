import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/show_delete_confirmation_dialog_in_app.dart';

import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

import '../../../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

import '../../../../../../../features/packages/data/model/get_packages_model/get_packages_model.dart';

import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_cubit.dart';
import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_state.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/pages_widgets/general_widgets/show_delete_confirmation_dialog_in_app.dart';

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
  final int? packageId;
  final bool isCreateMode;

  const PackageDataView({
    super.key,
    this.packageId,
    this.isCreateMode = false,
  });

  @override
  State<PackageDataView> createState() => PackageDataViewState();
}

class PackageDataViewState extends State<PackageDataView> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final packageIdController = TextEditingController();

  final packageNameController = TextEditingController();

  final packageLatinNameController = TextEditingController();

  final annualPriceController = TextEditingController();

  final monthPriceController = TextEditingController();

  final packageDiscController = TextEditingController();

  final packageLatinDiscController = TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool isEditMode = false;

  PackageModel? originalPackage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // CREATE
    // Create mode is editable immediately.
    if (widget.isCreateMode) {
      isEditMode = true;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

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

  // ============================================================
  // FILL DATA
  // ============================================================

  void _fillData(PackageModel package) {
    originalPackage = package;

    packageIdController.text =
        package.packageid?.toString() ?? '';

    packageNameController.text =
        package.packagename ?? '';

    packageLatinNameController.text =
        package.packagelatinname ?? '';

    annualPriceController.text =
        package.annualprice?.toString() ?? '';

    monthPriceController.text =
        package.monthprice?.toString() ?? '';

    packageDiscController.text =
        package.packagedisc ?? '';

    packageLatinDiscController.text =
        package.packagelatindisc ?? '';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // CREATE MODE
    // ==========================================================

    if (widget.isCreateMode) {
      return _buildCreateMode(context);
    }

    // ==========================================================
    // VIEW / EDIT MODE
    // ==========================================================

    return _buildViewEditMode(context);
  }

  // ============================================================
  // CREATE MODE
  // ============================================================

  Widget _buildCreateMode(BuildContext context) {
    return BlocConsumer<PackagesCubit, PackagesState>(
      listener: (context, state) {
        // ======================================================
        // CREATE SUCCESS
        // ======================================================

        if (state is PackagesCreateSuccess) {
          AppSnackBar.showSuccess(
            AppLanguageKeys.success,
          );

          Navigator.pop(
            context,
            true,
          );
        }

        // ======================================================
        // ERROR
        // ======================================================

        if (state is PackagesFailure) {
          AppSnackBar.showError(
            state.message,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PackagesLoading;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildPackageFields(),

              const SizedBox(height: 30),

              _buildCreateActions(
                context,
                isLoading,
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // VIEW / EDIT MODE
  // ============================================================

  Widget _buildViewEditMode(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.orangeColor,

      onRefresh: () async {
        if (widget.packageId == null) {
          return;
        }

        await context
            .read<PackagesCubit>()
            .getPackageById(
          packageId: widget.packageId!,
        );
      },

      child: SingleChildScrollView(
        physics:
        const AlwaysScrollableScrollPhysics(),

        child: BlocConsumer<PackagesCubit, PackagesState>(
          listener: (
              context,
              state,
              ) {
            // ==================================================
            // GET SUCCESS
            // ==================================================

            if (state is PackageGetByIdSuccess) {
              _fillData(
                state.package,
              );
            }

            // ==================================================
            // UPDATE SUCCESS
            // ==================================================

            if (state is PackagesUpdateSuccess) {
              AppSnackBar.showSuccess(
                AppLanguageKeys.success,
              );

              // Keep the updated package
              _fillData(
                state.package,
              );

              setState(() {
                isEditMode = false;
              });
            }

            // ==================================================
            // DELETE SUCCESS
            // ==================================================

            if (state is PackagesDeleteSuccess) {
              AppSnackBar.showSuccess(
                state.message,
              );

              Navigator.pop(
                context,
                true,
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

            if (state is PackagesFailure) {
              AppSnackBar.showError(
                state.message,
              );
            }
          },

          builder: (
              context,
              state,
              ) {
            // ==================================================
            // LOADING
            // ==================================================

            if (state is PackagesLoading) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child:
                  CupertinoActivityIndicator(),
                ),
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

            if (state is PackagesFailure) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: TextInAppWidget(
                    text: state.message,
                    textSize: 15,
                    textColor:
                    AppColors.greyColor,
                    isTextCenter: true,
                  ),
                ),
              );
            }

            // ==================================================
            // GET SUCCESS
            // ==================================================

            if (state is PackageGetByIdSuccess) {
              final package = state.package;

              if (originalPackage == null) {
                _fillData(package);
              }

              return _buildViewContent(
                context,
                package,
              );
            }

            // ==================================================
            // UPDATE SUCCESS
            // ==================================================

            if (state is PackagesUpdateSuccess) {
              return _buildViewContent(
                context,
                state.package,
              );
            }

            // ==================================================
            // DEFAULT
            // ==================================================

            return const SizedBox(
              height: 300,
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // PACKAGE FIELDS
  // Used by CREATE
  // and VIEW / EDIT
  // ============================================================

  Widget _buildPackageFields() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // ======================================================
        // PACKAGE INFORMATION
        // ======================================================

        const TextInAppWidget(
          text: AppLanguageKeys.packageName,
          textSize: 15,
          fontWeightIndex:
          FontSelectionData.mediumFontFamily,
          textColor:
          AppColors.orangeColor,
        ),

        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // ==================================================
            // ID
            // ==================================================

            if (!widget.isCreateMode)
              UserTextFieldWidget(
                controller:
                packageIdController,
                text:
                AppLanguageKeys.identity,
                readOnly: true,
                width: 250,
              ),

            // ==================================================
            // ARABIC NAME
            // ==================================================

            UserTextFieldWidget(
              controller:
              packageNameController,
              text:
              AppLanguageKeys.packageName,
              readOnly: !isEditMode,
              width: 250,
            ),

            // ==================================================
            // ENGLISH NAME
            // ==================================================

            UserTextFieldWidget(
              controller:
              packageLatinNameController,
              text:
              AppLanguageKeys.packageLatinName,
              readOnly: !isEditMode,
              width: 250,
            ),

            // ==================================================
            // ANNUAL PRICE
            // ==================================================

            UserTextFieldWidget(
              controller:
              annualPriceController,
              text:
              AppLanguageKeys.annualPrice,
              readOnly: !isEditMode,
              width: 250,
              digitOnly: true,
            ),

            // ==================================================
            // MONTH PRICE
            // ==================================================

            UserTextFieldWidget(
              controller:
              monthPriceController,
              text:
              AppLanguageKeys.monthlyPrice,
              readOnly: !isEditMode,
              width: 250,
              digitOnly: true,
            ),
          ],
        ),

        const SizedBox(height: 25),

        // ======================================================
        // DESCRIPTION
        // ======================================================

        const TextInAppWidget(
          text: AppLanguageKeys.description,
          textSize: 15,
          fontWeightIndex:
          FontSelectionData.mediumFontFamily,
          textColor:
          AppColors.orangeColor,
        ),

        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // ==================================================
            // ARABIC DESCRIPTION
            // ==================================================

            UserTextFieldWidget(
              controller:
              packageDiscController,
              text:
              AppLanguageKeys.packageDescription,
              readOnly: !isEditMode,
              width: 350,
              maxLines: 5,
            ),

            // ==================================================
            // ENGLISH DESCRIPTION
            // ==================================================

            UserTextFieldWidget(
              controller:
              packageLatinDiscController,
              text:
              AppLanguageKeys.packageLatinDisc,
              readOnly: !isEditMode,
              width: 350,
              maxLines: 5,
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // VIEW CONTENT
  // ============================================================

  Widget _buildViewContent(
      BuildContext context,
      PackageModel package,
      ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _buildPackageFields(),

          const SizedBox(height: 30),

          _buildActions(
            context,
            package,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CREATE ACTIONS
  // ============================================================

  Widget _buildCreateActions(
      BuildContext context,
      bool isLoading,
      ) {
    return Row(
      children: [
        // ======================================================
        // CREATE
        // ======================================================

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            AppColors.orangeColor,
          ),

          onPressed: isLoading
              ? null
              : _createPackage,

          child: isLoading
              ? const SizedBox(
            width: 18,
            height: 18,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : const TextInAppWidget(
            text:
            AppLanguageKeys.create,
            textSize: 13,
            textColor:
            AppColors.whiteColor,
          ),
        ),

        const SizedBox(width: 10),

        // ======================================================
        // CANCEL
        // ======================================================

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            AppColors.greyColor,
          ),

          onPressed: isLoading
              ? null
              : () {
            Navigator.pop(
              context,
              false,
            );
          },

          child: const TextInAppWidget(
            text: AppLanguageKeys.cancel,
            textSize: 13,
            textColor:
            AppColors.whiteColor,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VIEW / EDIT ACTIONS
  // ============================================================

  Widget _buildActions(
      BuildContext context,
      PackageModel package,
      ) {
    return BlocBuilder<PackagesCubit, PackagesState>(
      builder: (
          context,
          state,
          ) {
        final isLoading =
        state is PackagesLoading;

        return Row(
          children: [
            // ==================================================
            // EDIT / SAVE
            // ==================================================

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.orangeColor,
              ),

              onPressed: isLoading
                  ? null
                  : () {
                // ================================
                // VIEW -> EDIT
                // ================================

                if (!isEditMode) {
                  setState(() {
                    isEditMode = true;
                  });

                  return;
                }

                // ================================
                // EDIT -> SAVE
                // ================================

                _updatePackage(
                  package,
                );
              },

              child: isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : TextInAppWidget(
                text: isEditMode
                    ? AppLanguageKeys.save
                    : AppLanguageKeys.edit,
                textSize: 13,
                textColor:
                AppColors.whiteColor,
              ),
            ),

            const SizedBox(width: 10),

            // ==================================================
            // CANCEL
            // ==================================================

            if (isEditMode)
              ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.greyColor,
                ),

                onPressed: isLoading
                    ? null
                    : () {
                  // Restore original
                  // package data.

                  if (originalPackage !=
                      null) {
                    _fillData(
                      originalPackage!,
                    );
                  }

                  setState(() {
                    isEditMode = false;
                  });
                },

                child:
                const TextInAppWidget(
                  text:
                  AppLanguageKeys.cancel,
                  textSize: 13,
                  textColor:
                  AppColors.whiteColor,
                ),
              ),

            // ==================================================
            // DELETE
            // ==================================================

            if (!isEditMode) ...[
              const SizedBox(width: 10),

              ElevatedButton(
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.red,
                ),

                onPressed: isLoading
                    ? null
                    : () {
                  _deletePackage(
                    package.packageid,
                  );
                },

                child:
                const TextInAppWidget(
                  text:
                  AppLanguageKeys.delete,
                  textSize: 13,
                  textColor:
                  AppColors.whiteColor,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // ============================================================
  // CREATE PACKAGE
  // ============================================================

  void _createPackage() {
    final packageName =
    packageNameController.text.trim();

    final packageLatinName =
    packageLatinNameController.text.trim();

    final annualPrice =
    double.tryParse(
      annualPriceController.text.trim(),
    );

    final monthPrice =
    double.tryParse(
      monthPriceController.text.trim(),
    );

    final packageDisc =
    packageDiscController.text.trim();

    final packageLatinDisc =
    packageLatinDiscController.text.trim();

    // ==========================================================
    // VALIDATION
    // ==========================================================

    if (packageName.isEmpty) {
      AppSnackBar.showError(
        AppLanguageKeys.packageName,
      );
      return;
    }

    if (packageLatinName.isEmpty) {
      AppSnackBar.showError(
        AppLanguageKeys.packageLatinName,
      );
      return;
    }

    if (annualPrice == null) {
      AppSnackBar.showError(
        AppLanguageKeys.annualPrice,
      );
      return;
    }

    if (monthPrice == null) {
      AppSnackBar.showError(
        AppLanguageKeys.monthlyPrice,
      );
      return;
    }

    // ==========================================================
    // CREATE REQUEST
    // ==========================================================

    final package = PackageModel(
      packagename: packageName,
      packagelatinname:
      packageLatinName,
      annualprice: annualPrice,
      monthprice: monthPrice,
      packagedisc: packageDisc,
      packagelatindisc:
      packageLatinDisc,
    );

    // ==========================================================
    // API
    // ==========================================================

    context
        .read<PackagesCubit>()
        .createPackage(
      packageModel: package,
    );
  }

  // ============================================================
  // UPDATE PACKAGE
  // ============================================================

  void _updatePackage(
      PackageModel oldPackage,
      ) {
    final packageId =
        oldPackage.packageid;

    if (packageId == null) {
      AppSnackBar.showError(
        'Package ID is not available',
      );

      return;
    }

    final annualPrice =
    double.tryParse(
      annualPriceController.text.trim(),
    );

    final monthPrice =
    double.tryParse(
      monthPriceController.text.trim(),
    );

    if (annualPrice == null) {
      AppSnackBar.showError(
        AppLanguageKeys.annualPrice,
      );

      return;
    }

    if (monthPrice == null) {
      AppSnackBar.showError(
        AppLanguageKeys.monthlyPrice,
      );

      return;
    }

    final updatedPackage =
    PackageModel(
      packageid: packageId,

      packagename:
      packageNameController.text.trim(),

      packagelatinname:
      packageLatinNameController.text.trim(),

      annualprice: annualPrice,

      monthprice: monthPrice,

      packagedisc:
      packageDiscController.text.trim(),

      packagelatindisc:
      packageLatinDiscController.text.trim(),
    );

    context
        .read<PackagesCubit>()
        .updatePackage(
      packageModel:
      updatedPackage,
    );
  }

  // ============================================================
  // DELETE PACKAGE
  // ============================================================

  Future<void> _deletePackage(
      int? packageId,
      ) async {
    if (packageId == null) {
      AppSnackBar.showError(
        'Package ID is not available',
      );

      return;
    }

    final confirmed =
    await showDeleteConfirmationDialogInApp(
      context,
    );

    if (confirmed != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    await context
        .read<PackagesCubit>()
        .deletePackage(
      packageId: packageId,
    );
  }
}
