import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';

class ChangePasswordDialog extends StatefulWidget {
  final String phone;
  final String email;

  const ChangePasswordDialog({
    super.key,
    required this.phone,
    required this.email,
  });

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  int _currentStep = 0; // 0 = OTP, 1 = New Password

  // OTP Controllers & Focus Nodes
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  // Password Controllers
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSendingOtp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sendInitialOtp();
      }
    });
  }

  Future<void> _sendInitialOtp() async {
    setState(() => _isSendingOtp = true);

    try {
      final isArabic = context.locale.languageCode == 'ar';
      final cubit = context.read<AuthCubit>();

      final success = await cubit.sendOtp(
        email: widget.email,
        phone: widget.phone,
        isPasswordReset: true,
        isArabic: isArabic,
      );

      if (!mounted) return;

      setState(() => _isSendingOtp = false);

      if (success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _otpFocusNodes.isNotEmpty) {
            _otpFocusNodes[0].requestFocus();
          }
        });
      } else {
        AppSnackBar.showError(LocaleKeys.somethingWentWrong);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSendingOtp = false);
        AppSnackBar.showError(e.toString());
      }
    }
  }

  void _clearOtp() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    context.read<AuthCubit>().resetOtpError();
  }

  void _verifyOtp() {
    final enteredCode = _otpControllers.map((c) => c.text.trim()).join();
    if (enteredCode.length < 4) {
      AppSnackBar.showError(LocaleKeys.enterOtp);
      return;
    }

    context.read<AuthCubit>().validateOtp(enteredCode);
  }

  void _onDigitChanged(int index, String value) {
    context.read<AuthCubit>().resetOtpError();

    // Support pasting multi-character code
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.isNotEmpty) {
        for (int i = 0; i < 4; i++) {
          if (i < digits.length) {
            _otpControllers[i].text = digits[i];
          }
        }
        if (digits.length >= 4) {
          _otpFocusNodes[3].unfocus();
          _verifyOtp();
        } else {
          _otpFocusNodes[digits.length.clamp(0, 3)].requestFocus();
        }
        return;
      }
    }

    if (value.isNotEmpty) {
      if (index < 3) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
        final allFilled =
            _otpControllers.every((c) => c.text.trim().isNotEmpty);
        if (allFilled) {
          _verifyOtp();
        }
      }
    } else {
      if (index > 0) {
        _otpFocusNodes[index - 1].requestFocus();
      }
    }
  }

  Future<void> _resendOtp() async {
    _clearOtp();
    await context.read<AuthCubit>().resendOtp();
    if (mounted && _otpFocusNodes.isNotEmpty) {
      _otpFocusNodes[0].requestFocus();
    }
  }

  Future<void> _submitNewPassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty) {
      AppSnackBar.showError(LocaleKeys.authPasswordRequired);
      return;
    }

    if (password.length < 6) {
      AppSnackBar.showError(LocaleKeys.authWeakPassword);
      return;
    }

    if (password != confirmPassword) {
      AppSnackBar.showError(LocaleKeys.passwordsDoNotMatch);
      return;
    }

    await context.read<AuthCubit>().changePassword(
          user: widget.email,
          password: password,
        );
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthOtpSuccess ||
          current is AuthOtpError ||
          current is AuthOtpResendSuccess ||
          current is ChangePasswordSuccess ||
          current is ChangePasswordError,
      listener: (context, state) async {
        if (state is AuthOtpSuccess) {
          setState(() {
            _currentStep = 1;
          });
        } else if (state is AuthOtpError) {
          AppSnackBar.showError(state.message);
        } else if (state is AuthOtpResendSuccess) {
          AppSnackBar.showSuccess(LocaleKeys.success);
        } else if (state is ChangePasswordSuccess) {
          final newPassword = _passwordController.text.trim();
          await AuthLocalStorage.savePassword(newPassword);
          AppSnackBar.showSuccess(LocaleKeys.changePasswordSuccessfully);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else if (state is ChangePasswordError) {
          AppSnackBar.showError(state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        final isPasswordLoading = state is ChangePasswordLoading;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: AppColors.whiteColor,
          elevation: 10,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 24.0,
              ),
              child: _currentStep == 0
                  ? _buildOtpStep(cubit)
                  : _buildPasswordStep(isPasswordLoading),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpStep(AuthCubit cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top Header Row with Close
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.orangeColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_clock_outlined,
                color: AppColors.orangeColor,
                size: 24,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.darkColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Title
        const TextInAppWidget(
          text: LocaleKeys.changePassword,
          textSize: 20,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        const SizedBox(height: 8),

        // Subtitle
        const TextInAppWidget(
          text: LocaleKeys.enterOtp,
          textSize: 14,
          textColor: AppColors.greyColor,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          isTextCenter: true,
        ),
        const SizedBox(height: 6),

        // Phone Badge
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: [
            const TextInAppWidget(
              text: LocaleKeys.codeSentTo,
              textSize: 13,
              textColor: AppColors.greyColor,
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                widget.phone,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // OTP Boxes or Loading Spinner
        if (_isSendingOtp)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: AppColors.orangeColor,
                  strokeWidth: 2.5,
                ),
                SizedBox(height: 12),
                TextInAppWidget(
                  text: LocaleKeys.loading,
                  textSize: 13,
                  textColor: AppColors.greyColor,
                ),
              ],
            ),
          )
        else ...[
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: List.generate(
                4,
                (index) => _buildOtpBox(
                  index: index,
                  isError: cubit.isOtpError,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Timer / Resend
          if (cubit.isOtpResending)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.orangeColor,
              ),
            )
          else if (cubit.secondsRemaining > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: AppColors.redColor,
                ),
                const SizedBox(width: 4),
                Text(
                  "00:${cubit.secondsRemaining.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.redColor,
                  ),
                ),
              ],
            )
          else
            TextButton(
              onPressed: _resendOtp,
              child: const TextInAppWidget(
                text: LocaleKeys.Resend,
                textSize: 14,
                textColor: AppColors.orangeColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
            ),
        ],

        const SizedBox(height: 24),

        // Action Buttons Row
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isSendingOtp ? null : _verifyOtp,
                child: const TextInAppWidget(
                  text: LocaleKeys.verify,
                  textSize: 14,
                  textColor: AppColors.whiteColor,
                  fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                ),
              ),
            ),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.greyColor200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const TextInAppWidget(
                  text: LocaleKeys.cancel,
                  textSize: 14,
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpBox({required int index, required bool isError}) {
    return SizedBox(
      width: 58,
      height: 58,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.darkColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: AppColors.lightWhiteColor,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.greyColor200,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isError ? AppColors.redColor : AppColors.greyColor200,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isError ? AppColors.redColor : AppColors.orangeColor,
              width: 2,
            ),
          ),
        ),
        onChanged: (val) => _onDigitChanged(index, val),
      ),
    );
  }

  Widget _buildPasswordStep(bool isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.orangeColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: AppColors.orangeColor,
                size: 24,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.darkColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Title
        const TextInAppWidget(
          text: LocaleKeys.createNewPassword,
          textSize: 20,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        const SizedBox(height: 20),

        // New Password Field
        _buildPasswordField(
          label: LocaleKeys.Password,
          controller: _passwordController,
          obscureText: _obscurePassword,
          onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        const SizedBox(height: 16),

        // Confirm Password Field
        _buildPasswordField(
          label: LocaleKeys.confirmPasswordKey,
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          onToggleVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        const SizedBox(height: 24),

        // Action Buttons Row
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading ? null : _submitNewPassword,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const TextInAppWidget(
                        text: LocaleKeys.save,
                        textSize: 14,
                        textColor: AppColors.whiteColor,
                        fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                      ),
              ),
            ),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.greyColor200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: const TextInAppWidget(
                  text: LocaleKeys.cancel,
                  textSize: 14,
                  textColor: AppColors.darkColor,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: label,
          textSize: 14,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.darkColor,
          ),
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: const TextStyle(color: AppColors.greyColor),
            filled: true,
            fillColor: AppColors.lightWhiteColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.greyColor200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.greyColor200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.orangeColor,
                width: 1.8,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.greyColor,
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
