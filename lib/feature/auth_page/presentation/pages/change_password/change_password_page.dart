import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/auth_page/data/request/change_password_request/change_password_request.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/login_button_widget.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/login_image.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;

  const ChangePasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();

    confirmPasswordController = TextEditingController();

    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================================================
  // CHANGE PASSWORD
  // =========================================================

  void _changePassword() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final password = passwordController.text.trim();

    final confirmPassword = confirmPasswordController.text.trim();

    // =======================================================
    // CHECK PASSWORD MATCH
    // =======================================================

    if (password != confirmPassword) {
      AppSnackBar.showError(
        LocaleKeys.passwordsDoNotMatch,
      );

      return;
    }

    // =======================================================
    // CALL API
    // =======================================================

    context.read<AuthCubit>().changePassword(
          user: widget.email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ===================================================
          // FORM
          // ===================================================

          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: AppBar(
                    backgroundColor: AppColors.orangeColor,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // =================================
                              // PASSWORD
                              // =================================

                              const TextInAppWidget(
                                text: LocaleKeys.Password,
                                textColor: AppColors.darkColor,
                                textSize: 20,
                                fontWeightIndex:
                                    FontSelectionData.semiBoldFontFamily,
                              ),

                              UserTextFieldWidget(
                                type: UserFieldType.password,
                                controller: passwordController,
                              ),

                              // =================================
                              // CONFIRM PASSWORD
                              // =================================

                              const TextInAppWidget(
                                text: LocaleKeys.confirmPasswordKey,
                                textColor: AppColors.darkColor,
                                textSize: 20,
                                fontWeightIndex:
                                    FontSelectionData.semiBoldFontFamily,
                              ),

                              UserTextFieldWidget(
                                type: UserFieldType.password,
                                controller: confirmPasswordController,
                              ),

                              // =================================
                              // BUTTON
                              // =================================

                              BlocConsumer<AuthCubit, AuthState>(
                                listenWhen: (
                                  previous,
                                  current,
                                ) =>
                                    current is ChangePasswordSuccess ||
                                    current is ChangePasswordError,
                                listener: (
                                  context,
                                  state,
                                ) {
                                  // =========================
                                  // SUCCESS
                                  // =========================

                                  if (state is ChangePasswordSuccess) {
                                    AppSnackBar.showSuccess(
                                      state.message,
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }

                                  // =========================
                                  // ERROR
                                  // =========================

                                  if (state is ChangePasswordError) {
                                    AppSnackBar.showError(
                                      state.message,
                                    );
                                  }
                                },
                                builder: (
                                  context,
                                  state,
                                ) {
                                  final isLoading =
                                      state is ChangePasswordLoading;

                                  return LoginButtonWidget(
                                    text: LocaleKeys.send,
                                    isLoading: isLoading,
                                    onPressed:
                                        isLoading ? null : _changePassword,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===================================================
          // IMAGE
          // ===================================================

          if (MediaQuery.of(context).size.width > ValuesOfAllApp.mobileWidth)
            const LoginImage(),
        ],
      ),
    );
  }
}
