import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';
import '../../../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../../core/widgets/text_form_field_widget.dart';
import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_state.dart';

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

    noteStatusController.text = car?.currentStatus?.notes ?? '';
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
            LocaleKeys.success,
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
          text: widget.isEdit ? LocaleKeys.edit : LocaleKeys.create,
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
                    LocaleKeys.notes,
                    noteStatusController,
                  ),
                  _title(
                    LocaleKeys.currentStatus,
                  ),
                  _dropdown<int>(
                    value: selectedStatus,
                    hint: LocaleKeys.status,
                    items: const [
                      DropdownMenuItem<int>(
                        value: HarageStatus.created,
                        child: TextInAppWidget(
                          text: LocaleKeys.created,
                          textSize: 15,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: HarageStatus.pending,
                        child: TextInAppWidget(
                          text: LocaleKeys.pending,
                          textSize: 15,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: HarageStatus.sold,
                        child: TextInAppWidget(
                          text: LocaleKeys.sold,
                          textSize: 15,
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: HarageStatus.deleted,
                        child: TextInAppWidget(
                          text: LocaleKeys.deleted,
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
              text: LocaleKeys.cancel,
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
                        text:
                            widget.isEdit ? LocaleKeys.edit : LocaleKeys.create,
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
          maxLines: 5,
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
        LocaleKeys.selectServices,
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
