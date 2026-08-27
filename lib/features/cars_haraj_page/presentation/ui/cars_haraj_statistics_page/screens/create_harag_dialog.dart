import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../../../core/theming/image_compressor.dart';
import '../../../../../../../../../features/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';
import '../../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/harag_cubit/harag_cubit.dart';
import '../../../../../../../../../features/cars_haraj_page/presentation/bloc/harag_cubit/harag_state.dart';
import '../../../../../../../../../features/cars_haraj_page/data/request/create_update_harage_request/create_update_harage_request.dart';

class CreateHaragDialog extends StatefulWidget {
  final HarageData? car;

  const CreateHaragDialog({
    super.key,
    this.car,
  });

  bool get isEdit => car != null;

  @override
  State<CreateHaragDialog> createState() => _CreateHaragDialogState();
}

class _CreateHaragDialogState extends State<CreateHaragDialog> {
  final noteStatusController = TextEditingController();
  int? selectedStatus;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _initializeData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final cubit = context.read<HaragCubit>();

      cubit.getCarBrands();

    });
  }

  void _initializeData() {
    final car = widget.car;

    selectedStatus = car?.currentStatus?.status;

    noteStatusController.text =
        car?.currentStatus?.notes ?? '';
  }

  @override
  void dispose() {
    noteStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HaragCubit, HaragState>(
      listener: (context, state) {
        if (state is ChangeHarageStatusSuccess) {
          AppSnackBar.showSuccess(
            AppLanguageKeys.success,
          );

          Navigator.pop(context, true);
          return;
        }

        if (state is ChangeHarageStatusError) {
          AppSnackBar.showError(
            state.message,
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        title: TextInAppWidget(
          text: widget.isEdit ? AppLanguageKeys.edit : AppLanguageKeys.create,
          textSize: 20,
          textColor: AppColors.orangeColor,
          isTextCenter: true,
        ),

        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [

                  _field(
                    AppLanguageKeys.notes,
                    noteStatusController,
                  ),
                  _title(
                    AppLanguageKeys.currentStatus,
                  ),

                  _dropdown<int>(
                    value: selectedStatus,
                    hint: AppLanguageKeys.status,
                    items: const [
                      DropdownMenuItem<int>(
                        value: HarageStatus.created,
                        child: TextInAppWidget(
                          text: AppLanguageKeys.created,
                          textSize: 15,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: HarageStatus.pending,
                        child: TextInAppWidget(
                          text: AppLanguageKeys.pending,
                          textSize: 15,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: HarageStatus.sold,
                        child: TextInAppWidget(
                          text: AppLanguageKeys.sold,
                          textSize: 15,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: HarageStatus.deleted,
                        child: TextInAppWidget(
                          text: AppLanguageKeys.deleted,
                          textSize: 15,
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 15,
            ),
          ),

          // ======================================================
          // CREATE / UPDATE
          // ======================================================

          BlocBuilder<HaragCubit, HaragState>(
            builder: (context, state) {
              final isLoading = state is ChangeHarageStatusLoading;
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.orangeColor,
                  ),
                ),
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
                    : TextInAppWidget(
                  text: widget.isEdit
                      ? AppLanguageKeys.edit
                      : AppLanguageKeys.create,
                  textSize: 15,
                  textColor: AppColors.whiteColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }




  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.darkColor.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: TextInAppWidget(
            text: hint,
            textSize: 15,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _field(
      String title,

      TextEditingController controller, {
        bool isDouble = false,
        bool isInt = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(title),
        TextFormFieldWidget(
          textFormController: controller,
          isDigitDot: isDouble,
          isDigit: isInt,
          fillColor: AppColors.transparent,
          borderColor: AppColors.darkColor.withOpacity(0.2),
          hintTextSize: 12,
          hintTextColor: AppColors.orangeColor,
          textSize: 15,
          maxLines:5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }

            return null;
          },
        ),
      ],
    );
  }


  Widget _title(String text) {
    return TextInAppWidget(
      text: text,
      textSize: 13,
      textColor: AppColors.darkColor.withOpacity(0.6),
    );
  }


  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedStatus == null) {
      AppSnackBar.showError(
        AppLanguageKeys.selectServices,
      );
      return;
    }

    if (widget.car?.id == null) {
      AppSnackBar.showError(
        'Invalid harage ID',
      );
      return;
    }

    context.read<HaragCubit>().changeHarageStatus(
      harageId: widget.car!.id!,
      status: selectedStatus!,
      notes: noteStatusController.text.trim(),
    );
  }
}
