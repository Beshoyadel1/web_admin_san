import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class UpdateAdminPasswordDialog extends StatefulWidget {
  final CreateUserRequest admin;

  const UpdateAdminPasswordDialog({
    super.key,
    required this.admin,
  });

  @override
  State<UpdateAdminPasswordDialog> createState() =>
      _UpdateAdminPasswordDialogState();
}

class _UpdateAdminPasswordDialogState extends State<UpdateAdminPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty) {
      AppSnackBar.showError(LocaleKeys.Password);
      return;
    }

    if (password.length < 6) {
      AppSnackBar.showError(LocaleKeys.passwordAtLeastKey);
      return;
    }

    if (confirmPassword.isEmpty) {
      AppSnackBar.showError(LocaleKeys.confirmPasswordKey);
      return;
    }

    if (password != confirmPassword) {
      AppSnackBar.showError(LocaleKeys.passwordsDoNotMatch);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedAdmin = widget.admin.copyWith(password: password);
      final result = await updateUserFunction(createUserRequest: updatedAdmin);

      if (!mounted) return;

      if (result.success) {
        AppSnackBar.showSuccess(LocaleKeys.success);
        Navigator.pop(context, true);
      } else {
        AppSnackBar.showError(result.message);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.whiteColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextInAppWidget(
                      text: LocaleKeys.changePassword,
                      textSize: 18,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.darkGreyColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                UserTextFieldWidget(
                  controller: _passwordController,
                  text: LocaleKeys.Password,
                  type: UserFieldType.password,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),
                UserTextFieldWidget(
                  controller: _confirmPasswordController,
                  text: LocaleKeys.confirmPasswordKey,
                  type: UserFieldType.confirmPassword,
                  passwordControllerToMatch: _passwordController,
                  width: double.infinity,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                  strokeWidth: 2,
                                ),
                              )
                            : const TextInAppWidget(
                                text: LocaleKeys.save,
                                textSize: 14,
                                textColor: AppColors.whiteColor,
                                fontWeightIndex:
                                    FontSelectionData.semiBoldFontFamily,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: AppColors.darkGreyColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const TextInAppWidget(
                          text: LocaleKeys.cancel,
                          textSize: 14,
                          textColor: AppColors.darkColor,
                          fontWeightIndex: FontSelectionData.mediumFontFamily,
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
    );
  }
}
