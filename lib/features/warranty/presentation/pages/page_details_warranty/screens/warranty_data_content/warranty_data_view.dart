import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import '../../../../../../../../features/internal_services/presentation/pages/internal_orders/custom_widget/text_empty_view_data.dart';
import '../../../../../../../../features/warranty/data/model/warranty_model/warranty_model.dart';
import '../../../../../../../../features/warranty/presentation/bloc/warranty_cubit.dart';
import '../../../../../../../../features/warranty/presentation/bloc/warranty_state.dart';
import '../../../../../../../../features/warranty/presentation/custom_widget/duration_type_drop_down.dart';
import '../../../../../../../../features/warranty/presentation/custom_widget/duration_type_view.dart';

class WarrantyDataView extends StatefulWidget {
  final bool isCreateMode;

  const WarrantyDataView({
    super.key,
    this.isCreateMode = false,
  });

  @override
  State<WarrantyDataView> createState() => WarrantyDataViewState();
}

class WarrantyDataViewState extends State<WarrantyDataView> {
  final warrantyIdController = TextEditingController();

  final priceController = TextEditingController();

  final durationValueController = TextEditingController();

  int? selectedDurationTypeId;

  bool isEditMode = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    // Create mode => fields editable immediately
    if (widget.isCreateMode) {
      isEditMode = true;
    }
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    warrantyIdController.dispose();
    priceController.dispose();
    durationValueController.dispose();

    super.dispose();
  }

  // =========================================================
  // FILL DATA
  // =========================================================

  void _fillData(
      WarrantyModel warranty,
      ) {
    warrantyIdController.text =
        warranty.id?.toString() ?? '';

    priceController.text =
        warranty.price?.toString() ?? '';

    durationValueController.text =
        warranty.durationvalue?.toString() ?? '';

    selectedDurationTypeId =
        warranty.durationtype;
  }



  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    return RefreshIndicator(
      color: AppColors.orangeColor,

      onRefresh: () async {
        // ============================================
        // CREATE MODE
        // ============================================

        if (widget.isCreateMode) {
          return;
        }

        // ============================================
        // VIEW / EDIT MODE
        // ============================================

        final id =
            context.read<WarrantyCubit>().warranty?.id;

        if (id != null) {
          await context
              .read<WarrantyCubit>()
              .getApprovalInfoById(
            id: id,
          );
        }
      },

      child: SingleChildScrollView(
        physics:
        const AlwaysScrollableScrollPhysics(),

        child: BlocConsumer<WarrantyCubit, WarrantyState>(
          // =====================================================
          // LISTENER
          // =====================================================

          listener: (
              context,
              state,
              ) {
            // ============================================
            // DETAILS SUCCESS
            // ============================================

            if (state is WarrantyDetailsSuccess) {
              _fillData(
                state.warranty,
              );
            }

            // ============================================
            // CREATE SUCCESS
            // ============================================

            if (state is WarrantyCreateSuccess) {
              AppSnackBar.showSuccess(
                AppLanguageKeys.success,
              );

              Navigator.pop(
                context,
                true,
              );
            }

            // ============================================
            // CREATE ERROR
            // ============================================

            if (state is WarrantyCreateError) {
              AppSnackBar.showError(
                state.message,
              );
            }

            // ============================================
            // UPDATE SUCCESS
            // ============================================

            if (state is WarrantyUpdateSuccess) {
              _fillData(
                state.warranty,
              );

              setState(() {
                isEditMode = false;
              });

              AppSnackBar.showSuccess(
                AppLanguageKeys.success,
              );

              // Return true to ViewAllWarranty
              Navigator.pop(
                context,
                true,
              );
            }

            // ============================================
            // UPDATE ERROR
            // ============================================

            if (state is WarrantyUpdateError) {
              AppSnackBar.showError(
                state.message,
              );
            }
          },

          // =====================================================
          // BUILDER
          // =====================================================

          builder: (
              context,
              state,
              ) {
            // ============================================
            // CREATE MODE INITIAL STATE
            // ============================================

            if (widget.isCreateMode &&
                state is WarrantyInitial) {
              return _buildCreateContent(
                context,
              );
            }

            // ============================================
            // GENERAL LOADING
            // ============================================

            if (state is WarrantyLoading) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            // ============================================
            // CREATE LOADING
            // ============================================

            if (state is WarrantyCreateLoading) {
              return _buildCreateContent(
                context,
                isLoading: true,
              );
            }

            // ============================================
            // CREATE ERROR
            // ============================================

            if (state is WarrantyCreateError) {
              return _buildCreateContent(
                context,
              );
            }

            // ============================================
            // GENERAL ERROR
            // ============================================

            if (state is WarrantyError) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: TextEmptyViewData(
                    text: state.message,
                  ),
                ),
              );
            }

            // ============================================
            // DETAILS SUCCESS
            // ============================================

            if (state is WarrantyDetailsSuccess) {
              if (warrantyIdController.text.isEmpty) {
                _fillData(
                  state.warranty,
                );
              }

              return _buildContent(
                context,
                state.warranty,
              );
            }

            // ============================================
            // UPDATE LOADING
            // ============================================

            if (state is WarrantyUpdateLoading) {
              final warranty =
                  context.read<WarrantyCubit>().warranty;

              if (warranty != null) {
                return _buildContent(
                  context,
                  warranty,
                  isLoading: true,
                );
              }

              return const SizedBox(
                height: 300,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            // ============================================
            // UPDATE SUCCESS
            // ============================================

            if (state is WarrantyUpdateSuccess) {
              return _buildContent(
                context,
                state.warranty,
              );
            }

            // ============================================
            // FALLBACK CREATE
            // ============================================

            if (widget.isCreateMode) {
              return _buildCreateContent(
                context,
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

  // =========================================================
  // CREATE CONTENT
  // =========================================================

  Widget _buildCreateContent(
      BuildContext context, {
        bool isLoading = false,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),

        // ===================================================
        // TITLE
        // ===================================================

        const TextInAppWidget(
          text: AppLanguageKeys.warranty,
          textSize: 15,
          fontWeightIndex:
          FontSelectionData.mediumFontFamily,
          textColor:
          AppColors.orangeColor,
        ),

        const SizedBox(
          height: 15,
        ),

        // ===================================================
        // FORM
        // ===================================================

        Wrap(
          spacing: 10,
          runSpacing: 15,
          children: [
            // ===============================================
            // PRICE
            // ===============================================

            UserTextFieldWidget(
              controller:
              priceController,
              text:
              AppLanguageKeys.price,
              readOnly: isLoading,
              width: 250,
              digitOnly: true,
            ),

            // ===============================================
            // DURATION TYPE
            // ===============================================

            DurationTypeDropdown(
              selectedDurationTypeId:
              selectedDurationTypeId,
              onChanged: isLoading
                  ? (_) {}
                  : (value) {
                setState(() {
                  selectedDurationTypeId =
                      value;
                });
              },
            ),

            // ===============================================
            // DURATION VALUE
            // ===============================================

            UserTextFieldWidget(
              controller:
              durationValueController,
              text:
              AppLanguageKeys.durationValue,
              readOnly: isLoading,
              width: 250,
              digitOnly: true,

            ),
          ],
        ),

        const SizedBox(
          height: 30,
        ),

        // ===================================================
        // CREATE ACTIONS
        // ===================================================

        _buildCreateActions(
          context,
          isLoading,
        ),
      ],
    );
  }

  // =========================================================
  // CREATE ACTIONS
  // =========================================================

  Widget _buildCreateActions(
      BuildContext context,
      bool isLoading,
      ) {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            AppColors.orangeColor,
          ),

          onPressed: isLoading
              ? null
              : _createWarranty,

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
            AppLanguageKeys.save,
            textSize: 13,
            textColor:
            AppColors.whiteColor,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

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
            text:
            AppLanguageKeys.cancel,
            textSize: 13,
            textColor:
            AppColors.whiteColor,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // VIEW / EDIT CONTENT
  // =========================================================

  Widget _buildContent(
      BuildContext context,
      WarrantyModel warranty, {
        bool isLoading = false,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),

        // ===================================================
        // TITLE
        // ===================================================

        const TextInAppWidget(
          text:
          AppLanguageKeys.warranty,
          textSize: 15,
          fontWeightIndex:
          FontSelectionData.mediumFontFamily,
          textColor:
          AppColors.orangeColor,
        ),

        const SizedBox(
          height: 15,
        ),

        // ===================================================
        // DATA
        // ===================================================

        Wrap(
          spacing: 10,
          runSpacing: 15,
          children: [
            // ===============================================
            // ID
            // ===============================================

            UserTextFieldWidget(
              controller:
              warrantyIdController,
              text:
              AppLanguageKeys.identity,
              readOnly: true,
              width: 250,
              digitOnly: true,
            ),

            // ===============================================
            // PRICE
            // ===============================================

            UserTextFieldWidget(
              controller:
              priceController,
              text:
              AppLanguageKeys.price,
              readOnly:
              !isEditMode ||
                  isLoading,
              width: 250,
              digitOnly: true,
            ),

            // ===============================================
            // DURATION TYPE
            // ===============================================

            if (isEditMode)
              DurationTypeDropdown(
                selectedDurationTypeId:
                selectedDurationTypeId,
                onChanged: isLoading
                    ? (_) {}
                    : (value) {
                  setState(() {
                    selectedDurationTypeId =
                        value;
                  });
                },
              )
            else
              DurationTypeView(
                durationTypeId:
                selectedDurationTypeId,
                text:
                AppLanguageKeys.durationType,
                width: 250,
              ),

            // ===============================================
            // DURATION VALUE
            // ===============================================

            UserTextFieldWidget(
              controller:
              durationValueController,
              text:
              AppLanguageKeys.durationValue,
              readOnly:
              !isEditMode ||
                  isLoading,
              width: 250,
              type: UserFieldType.number,
            ),
          ],
        ),

        const SizedBox(
          height: 30,
        ),

        // ===================================================
        // ACTIONS
        // ===================================================

        _buildActions(
          context,
          warranty,
          isLoading,
        ),
      ],
    );
  }

  // =========================================================
  // VIEW / EDIT ACTIONS
  // =========================================================

  Widget _buildActions(
      BuildContext context,
      WarrantyModel warranty,
      bool isLoading,
      ) {
    return Row(
      children: [
        // ===================================================
        // EDIT / SAVE
        // ===================================================

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            AppColors.orangeColor,
          ),

          onPressed: isLoading
              ? null
              : () {
            // ------------------------------
            // VIEW -> EDIT
            // ------------------------------

            if (!isEditMode) {
              setState(() {
                isEditMode = true;
              });

              return;
            }

            // ------------------------------
            // EDIT -> UPDATE
            // ------------------------------

            _updateWarranty(
              warranty,
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

        // ===================================================
        // CANCEL
        // ===================================================

        if (isEditMode) ...[
          const SizedBox(
            width: 10,
          ),

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
              _fillData(
                warranty,
              );

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
        ],
      ],
    );
  }

  // =========================================================
  // CREATE
  // =========================================================

  void _createWarranty() {
    // ============================================
    // PRICE
    // ============================================

    final priceText =
    priceController.text.trim();

    if (priceText.isEmpty) {
      AppSnackBar.showError(
        AppLanguageKeys.price,
      );

      return;
    }

    final price =
    num.tryParse(priceText);

    if (price == null) {
      AppSnackBar.showError(
        'Invalid price',
      );

      return;
    }

    // ============================================
    // DURATION TYPE
    // ============================================

    final durationType =
        selectedDurationTypeId;

    if (durationType == null) {
      AppSnackBar.showError(
        AppLanguageKeys.selectDurationType,
      );

      return;
    }

    // ============================================
    // DURATION VALUE
    // ============================================

    final durationValueText =
    durationValueController.text.trim();

    if (durationValueText.isEmpty) {
      AppSnackBar.showError(
        AppLanguageKeys.durationValue,
      );

      return;
    }

    final durationValue =
    int.tryParse(
      durationValueText,
    );

    if (durationValue == null ||
        durationValue <= 0) {
      AppSnackBar.showError(
        'Invalid duration value',
      );

      return;
    }

    // ============================================
    // CREATE
    // ============================================

    context.read<WarrantyCubit>().createWarranty(
      warrantyModel: WarrantyModel(
        price: price,
        durationtype:
        durationType,
        durationvalue:
        durationValue,
      ),
    );
  }

  // =========================================================
  // UPDATE
  // =========================================================

  void _updateWarranty(
      WarrantyModel oldWarranty,
      ) {
    // ============================================
    // ID
    // ============================================

    final id = oldWarranty.id;

    if (id == null || id <= 0) {
      AppSnackBar.showError(
        'Warranty ID is not available',
      );

      return;
    }

    // ============================================
    // PRICE
    // ============================================

    final price =
    num.tryParse(
      priceController.text.trim(),
    );

    if (price == null) {
      AppSnackBar.showError(
        'Invalid price',
      );

      return;
    }

    // ============================================
    // DURATION TYPE
    // ============================================

    final durationType =
        selectedDurationTypeId;

    if (durationType == null) {
      AppSnackBar.showError(
        AppLanguageKeys.selectDurationType,
      );

      return;
    }

    // ============================================
    // DURATION VALUE
    // ============================================

    final durationValue =
    int.tryParse(
      durationValueController.text.trim(),
    );

    if (durationValue == null ||
        durationValue <= 0) {
      AppSnackBar.showError(
        'Invalid duration value',
      );

      return;
    }

    // ============================================
    // UPDATE
    // ============================================

    context.read<WarrantyCubit>().updateWarranty(
      warrantyModel: WarrantyModel(
        id: id,
        price: price,
        durationtype:
        durationType,
        durationvalue:
        durationValue,
      ),
    );
  }
}