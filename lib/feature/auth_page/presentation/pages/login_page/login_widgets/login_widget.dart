import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/constants/constants.dart';

import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/services/fcm_service.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/data/request/login_request/login_request.dart';
import 'package:web_admin_san/feature/auth_page/presentation/auth_gate.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/check_email_exist/check_email_exist_page.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/login_button_widget.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late TextEditingController userNameController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    userNameController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // Pre-warm FCM token fetch while user types credentials
    FcmService.instance.getToken(vapidKey: FcmConfig.webVapidKey);
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TextInAppWidget(
            text: LocaleKeys.Login,
            textSize: 20,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),
          UserTextFieldWidget(
            controller: userNameController,
            type: UserFieldType.email,
            text: LocaleKeys.Email,
          ),
          UserTextFieldWidget(
            controller: passwordController,
            type: UserFieldType.password,
            text: LocaleKeys.Password,
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                current is AuthLoginSuccess || current is AuthLoginError,
            listener: (context, state) {
              if (state is AuthLoginSuccess) {
                AppSnackBar.showSuccess(
                  LocaleKeys.success,
                );

                Navigator.pushReplacement(
                  context,
                  NavigateToPageWidget(
                    const AuthGate(),
                  ),
                );
              }

              if (state is AuthLoginError) {
                AppSnackBar.showError(
                  state.message,
                );
              }
            },
            buildWhen: (previous, current) =>
                current is AuthLoginLoading || previous is AuthLoginLoading,
            builder: (context, state) {
              final isLoading = state is AuthLoginLoading;

              return LoginButtonWidget(
                text: LocaleKeys.Login,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        final email = userNameController.text.trim();
                        final password = passwordController.text.trim();
                        if (email.isEmpty || password.isEmpty) {
                          AppSnackBar.showError(
                            LocaleKeys.enterYourData,
                          );
                          return;
                        }

                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );

                        if (!emailRegex.hasMatch(email)) {
                          AppSnackBar.showError(
                            LocaleKeys.pleaseEnterValidEmail,
                          );
                          return;
                        }

                        if (!formKey.currentState!.validate()) return;

                        final fcmToken = await FcmService.instance
                            .getToken(vapidKey: FcmConfig.webVapidKey);

                        final loginRequest = LoginRequest(
                          user: userNameController.text.trim(),
                          password: passwordController.text.trim(),
                          type: UserType.adminUser,
                          fcmToken: fcmToken.isNotEmpty ? fcmToken : null,
                        );

                        if (context.mounted) {
                          context.read<AuthCubit>().login(loginRequest);
                        }
                      },
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextInAppWidget(
                text: AppVersion.version,
                textSize: 12,
                fontWeightIndex: FontSelectionData.regularFontFamily,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                NavigateToPageWidget(
                  const CheckEmailExistPage(),
                ),
              );
            },
            child: const TextInAppWidget(
              text: LocaleKeys.forgotPasswordKey,
              textSize: 14,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
          ),
        ],
      ),
    );
  }
}
