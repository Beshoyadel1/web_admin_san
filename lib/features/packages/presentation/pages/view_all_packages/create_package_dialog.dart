import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/text_styles.dart';

import '../../../../../../../features/packages/data/model/get_packages_model/get_packages_model.dart';
import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_cubit.dart';
import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_state.dart';

class CreatePackageDialog extends StatefulWidget {
  const CreatePackageDialog({
    super.key,
  });

  @override
  State<CreatePackageDialog> createState() =>
      _CreatePackageDialogState();
}

class _CreatePackageDialogState
    extends State<CreatePackageDialog> {

  final _formKey = GlobalKey<FormState>();

  final packageNameController =
  TextEditingController();

  final packageLatinNameController =
  TextEditingController();

  final annualPriceController =
  TextEditingController();

  final monthPriceController =
  TextEditingController();

  final packageDiscController =
  TextEditingController();

  final packageLatinDiscController =
  TextEditingController();

  @override
  void dispose() {
    packageNameController.dispose();
    packageLatinNameController.dispose();
    annualPriceController.dispose();
    monthPriceController.dispose();
    packageDiscController.dispose();
    packageLatinDiscController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackagesCubit, PackagesState>(
      listener: (context, state) {


        if (state is PackagesCreateSuccess) {
          Navigator.pop(
            context,
            true,
          );
        }
      },

      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        title: const TextInAppWidget(
          text: AppLanguageKeys.create,
          textSize: 20,
          textColor: AppColors.orangeColor,
          isTextCenter: true,
        ),

        content: SizedBox(
          width: 500,

          child: SingleChildScrollView(
            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                spacing: 15,
                children: [
                  _field(
                    AppLanguageKeys.packageName,
                    packageNameController,
                  ),


                  _field(
                    AppLanguageKeys.packageLatinName,
                    packageLatinNameController,
                  ),


                  Row(
                    spacing: 10,
                    children: [

                      Expanded(
                        child: _field(
                          AppLanguageKeys.annualPrice,
                          annualPriceController,
                          isDouble: true,
                        ),
                      ),

                      Expanded(
                        child: _field(
                          AppLanguageKeys.monthlyPrice,
                          monthPriceController,
                          isDouble: true,
                        ),
                      ),
                    ],
                  ),


                  _field(
                    AppLanguageKeys.packageDescription,
                    packageDiscController,
                    maxLines: 3,
                  ),

                  // =========================
                  // ENGLISH DESCRIPTION
                  // =========================

                  _field(
                    AppLanguageKeys.packageLatinDisc,
                    packageLatinDiscController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),

        actions: [

          // =========================
          // CANCEL
          // =========================

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 15,
            ),
          ),

          // =========================
          // CREATE
          // =========================

          BlocBuilder<PackagesCubit, PackagesState>(
            builder: (context, state) {

              final isLoading =
              state is PackagesLoading;

              return ElevatedButton(
                onPressed:
                isLoading ? null : _submit,

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
                  text: AppLanguageKeys.create,
                  textSize: 15,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FIELD
  // =========================================================

  Widget _field(
      String title,
      TextEditingController controller, {
        bool isDouble = false,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        TextInAppWidget(
          text: title,
          textSize: 13,
          textColor:
          AppColors.darkColor.withOpacity(0.6),
        ),

        const SizedBox(height: 5),

        TextFormFieldWidget(
          textFormController: controller,

          isDigitDot: isDouble,

          maxLines: maxLines,

          fillColor: AppColors.transparent,

          borderColor:
          AppColors.darkColor.withOpacity(0.2),

          hintTextSize: 12,

          hintTextColor:
          AppColors.orangeColor,

          textSize: 15,

          validator: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return '';
            }

            return null;
          },
        ),
      ],
    );
  }


  void _submit() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<PackagesCubit>().createPackage(
      packageModel: PackageModel(
        packagename:
        packageNameController.text.trim(),

        packagelatinname:
        packageLatinNameController.text.trim(),

        annualprice:
        double.tryParse(
          annualPriceController.text.trim(),
        ) ?? 0,

        monthprice:
        double.tryParse(
          monthPriceController.text.trim(),
        ) ?? 0,

        packagedisc:
        packageDiscController.text.trim(),

        packagelatindisc:
        packageLatinDiscController.text.trim(),
      ),
    );
  }
}