import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';

class ChangeEmailDialog extends StatefulWidget {
  final String phone;
  final String currentEmail;

  const ChangeEmailDialog({
    super.key,
    required this.phone,
    required this.currentEmail,
  });

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  int _currentStep = 0; // 0 = OTP, 1 = New Email

  // OTP Controllers & Focus Nodes
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  // Email Controller
  final TextEditingController _newEmailController = TextEditingController();

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

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _sendInitialOtp() async {
    setState(() => _isSendingOtp = true);

    try {
      final isArabic = context.locale.languageCode == 'ar';
      final cubit = context.read<AuthCubit>();

      final success = await cubit.sendOtp(
        email: widget.currentEmail,
        phone: widget.phone,
        isPasswordReset: false,
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

    // Paste support
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

  Future<void> _submitNewEmail() async {
    final email = _newEmailController.text.trim();

    if (email.isEmpty) {
      AppSnackBar.showError(LocaleKeys.authEmailRequired);
      return;
    }

    final emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(email)) {
      AppSnackBar.showError(LocaleKeys.pleaseEnterValidEmail);
      return;
    }

    if (email.toLowerCase() == widget.currentEmail.toLowerCase()) {
      AppSnackBar.showError(LocaleKeys.emailExist);
      return;
    }

    await context.read<AuthCubit>().updateUser(
          CreateUserRequest(
            email: email,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthOtpSuccess ||
          current is AuthOtpError ||
          current is AuthOtpResendSuccess ||
          current is AuthUpdateSuccess ||
          current is AuthUpdateError,
      listener: (context, state) async {
        if (state is AuthOtpSuccess) {
          setState(() {
            _currentStep = 1;
          });
        } else if (state is AuthOtpError) {
          AppSnackBar.showError(state.message);
        } else if (state is AuthOtpResendSuccess) {
          AppSnackBar.showSuccess(LocaleKeys.success);
        } else if (state is AuthUpdateSuccess) {
          AppSnackBar.showSuccess(LocaleKeys.success);
          if (context.mounted) {
            Navigator.of(context).pop(true);
          }
        } else if (state is AuthUpdateError) {
          AppSnackBar.showError(state.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        final isUpdating = state is AuthUpdateLoading;

        return Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 460,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dialog Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextInAppWidget(
                        text: LocaleKeys.changeEmail,
                        textSize: 17,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: AppColors.darkGreyColor,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Step Indicator
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.orangeColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: _currentStep == 1
                                ? AppColors.orangeColor
                                : AppColors.cardStroke,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // STEP 0: OTP
                  if (_currentStep == 0) ...[
                    const TextInAppWidget(
                      text: LocaleKeys.pleaseEnterThePinSentToYourPhoneNumber,
                      textSize: 14,
                      textColor: AppColors.darkGreyColor,
                    ),
                    const SizedBox(height: 6),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        widget.phone,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // OTP Input Fields
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 52,
                            height: 52,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: AppColors.greyColorSearch,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _otpControllers[index].text.isNotEmpty
                                    ? AppColors.orangeColor
                                    : AppColors.cardStroke,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _otpFocusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkColor,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (val) =>
                                    _onDigitChanged(index, val),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Resend Timer / Button
                    Center(
                      child: cubit.isOtpResending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.orangeColor,
                              ),
                            )
                          : cubit.secondsRemaining > 0
                              ? Row(
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
                              : MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: TextButton(
                                    onPressed: _resendOtp,
                                    child: const TextInAppWidget(
                                      text: LocaleKeys.Resend,
                                      textSize: 14,
                                      textColor: AppColors.orangeColor,
                                      fontWeightIndex:
                                          FontSelectionData.boldFontFamily,
                                    ),
                                  ),
                                ),
                    ),
                    const SizedBox(height: 24),

                    // Verify and Cancel Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orangeColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _isSendingOtp ? null : _verifyOtp,
                            child: const TextInAppWidget(
                              text: LocaleKeys.verify,
                              textColor: AppColors.whiteColor,
                              textSize: 14,
                              fontWeightIndex:
                                  FontSelectionData.mediumFontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                color: AppColors.cardStroke,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const TextInAppWidget(
                              text: LocaleKeys.cancel,
                              textColor: AppColors.darkColor,
                              textSize: 14,
                              fontWeightIndex:
                                  FontSelectionData.regularFontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // STEP 1: NEW EMAIL
                  if (_currentStep == 1) ...[
                    const TextInAppWidget(
                      text: LocaleKeys.enterNewEmail,
                      textSize: 14,
                      textColor: AppColors.darkGreyColor,
                    ),
                    const SizedBox(height: 18),

                    TextField(
                      controller: _newEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.newEmail.tr(),
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGreyColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          size: 20,
                          color: AppColors.darkGreyColor,
                        ),
                        filled: true,
                        fillColor: AppColors.greyColorSearch,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.cardStroke,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.orangeColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save and Cancel Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orangeColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isUpdating ? null : _submitNewEmail,
                            child: isUpdating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.whiteColor,
                                    ),
                                  ),
                                )
                              : const TextInAppWidget(
                                  text: LocaleKeys.saveChanges,
                                  textColor: AppColors.whiteColor,
                                  textSize: 14,
                                  fontWeightIndex:
                                      FontSelectionData.mediumFontFamily,
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                color: AppColors.cardStroke,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const TextInAppWidget(
                              text: LocaleKeys.cancel,
                              textColor: AppColors.darkColor,
                              textSize: 14,
                              fontWeightIndex:
                                  FontSelectionData.regularFontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
