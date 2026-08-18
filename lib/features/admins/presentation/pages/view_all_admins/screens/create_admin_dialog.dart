import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_state.dart';

import 'package:web_admin_san/features/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/create_user_request.dart';

import 'package:web_admin_san/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

class CreateAdminDialog extends StatefulWidget {
  const CreateAdminDialog({
    super.key,
  });

  @override
  State<CreateAdminDialog> createState() => _CreateAdminDialogState();
}

class _CreateAdminDialogState extends State<CreateAdminDialog> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final password = passwordController.text.trim();

    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      AppSnackBar.showError(
        AppLanguageKeys.passwordsDoNotMatch,
      );
      return;
    }

    final request = CreateUserRequest(
      username: usernameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      password: password,
      type: 6,
      adminDetails: const AdminDetailsRequest(),
    );

    debugPrint(
      '========== CREATE ADMIN ==========',
    );

    context.read<AdminsCubit>().createAdmin(
          request,
        );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminsCubit, AdminsState>(
      listener: (context, state) {
        // =====================================================
        // SUCCESS
        // =====================================================

        if (state is AdminsCreateSuccess) {
          AppSnackBar.showSuccess(
            AppLanguageKeys.success,
          );

          Navigator.of(context).pop(true);
        }

        // =====================================================
        // ERROR
        // =====================================================

        if (state is AdminsCreateError) {
          AppSnackBar.showError(
            state.error,
          );
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        title: const TextInAppWidget(
          text: AppLanguageKeys.createAccountKey,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  // =================================================
                  // USERNAME
                  // =================================================

                  UserTextFieldWidget(
                    type: UserFieldType.name,
                    controller: usernameController,
                    text: AppLanguageKeys.userName,
                    fillColor: AppColors.transparent,
                  ),

                  // =================================================
                  // PHONE
                  // =================================================

                  UserTextFieldWidget(
                    type: UserFieldType.phone,
                    controller: phoneController,
                    text: AppLanguageKeys.phoneNumber,
                    fillColor: AppColors.transparent,
                  ),

                  // =================================================
                  // EMAIL
                  // =================================================

                  UserTextFieldWidget(
                    type: UserFieldType.email,
                    controller: emailController,
                    text: AppLanguageKeys.email,
                    fillColor: AppColors.transparent,
                  ),

                  // =================================================
                  // PASSWORD
                  // =================================================

                  UserTextFieldWidget(
                    type: UserFieldType.password,
                    controller: passwordController,
                    text: AppLanguageKeys.password,
                    fillColor: AppColors.transparent,
                  ),

                  // =================================================
                  // CONFIRM PASSWORD
                  // =================================================

                  UserTextFieldWidget(
                    type: UserFieldType.password,
                    controller: confirmPasswordController,
                    text: AppLanguageKeys.confirmPasswordKey,
                    fillColor: AppColors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ),

        // =========================================================
        // ACTIONS
        // =========================================================

        actions: [
          // CANCEL
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const TextInAppWidget(
              text: AppLanguageKeys.cancel,
              textSize: 14,
            ),
          ),

          // CREATE
          BlocBuilder<AdminsCubit, AdminsState>(
            builder: (context, state) {
              final isLoading = state is AdminsCreateLoading;

              return ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const TextInAppWidget(
                        text: AppLanguageKeys.create,
                        textSize: 14,
                        textColor: AppColors.whiteColor,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
