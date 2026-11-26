import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/admin_details_request.dart';

import '../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/services/fcm_service.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/login_button_widget.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import '../../login_page/login_widgets/login_language_button_widget.dart';

class SignUpMobileWidget extends StatefulWidget {
  const SignUpMobileWidget({super.key});

  @override
  State<SignUpMobileWidget> createState() => _SignUpMobileWidgetState();
}

class _SignUpMobileWidgetState extends State<SignUpMobileWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: AppBar(backgroundColor: AppColors.seaBlueColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const LoginLanguageButtonWidget(),
                    Image.asset(
                      AppImageKeys.sarLogoEmp,
                      height: 50,
                      width: 170,
                      fit: BoxFit.fill,
                    ),
                    const TextInAppWidget(
                      text: LocaleKeys.signUpTitleKey,
                      textSize: 25,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                    UserTextFieldWidget(
                      type: UserFieldType.name,
                      controller: usernameController,
                      text: LocaleKeys.userName,
                    ),
                    UserTextFieldWidget(
                      type: UserFieldType.phone,
                      controller: phoneController,
                      text: LocaleKeys.phoneNumberKey,
                    ),
                    UserTextFieldWidget(
                      type: UserFieldType.email,
                      controller: emailController,
                      text: LocaleKeys.emailKey,
                    ),
                    UserTextFieldWidget(
                      type: UserFieldType.password,
                      controller: passwordController,
                      text: LocaleKeys.Password,
                    ),
                    UserTextFieldWidget(
                      type: UserFieldType.password,
                      controller: confirmPasswordController,
                      text: LocaleKeys.confirmPasswordKey,
                    ),
                    const SizedBox(height: 10),
                    BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) async {
                        if (state is AuthSignupSuccess) {
                          AppSnackBar.showSuccess(
                            LocaleKeys.success,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }

                        if (state is AuthSignupError) {
                          AppSnackBar.showError(
                            state.message,
                          );
                        }
                      },
                      child: BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>
                            current is AuthSignupLoading ||
                            current is AuthSignupSuccess ||
                            current is AuthSignupError ||
                            previous is AuthSignupLoading,
                        builder: (context, state) {
                          final isLoading = state is AuthSignupLoading;

                          return LoginButtonWidget(
                            text: LocaleKeys.signUpTitleKey,
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final password =
                                        passwordController.text.trim();
                                    final confirm =
                                        confirmPasswordController.text.trim();

                                    if (password != confirm) {
                                      AppSnackBar.showError(
                                          LocaleKeys.passwordsDoNotMatch);
                                      return;
                                    }

                                    final fcmToken = await FcmService.instance
                                        .getToken(
                                            vapidKey: FcmConfig.webVapidKey);

                                    if (!context.mounted) return;

                                    context.read<AuthCubit>().signup(
                                          CreateUserRequest(
                                            username:
                                                usernameController.text.trim(),
                                            phone: phoneController.text.trim(),
                                            email: emailController.text.trim(),
                                            password: password,
                                            type: UserType.employeeUser,
                                            adminDetails:
                                                const AdminDetailsRequest(),
                                            fcmToken: fcmToken.isNotEmpty
                                                ? fcmToken
                                                : null,
                                          ),
                                        );
                                  },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
