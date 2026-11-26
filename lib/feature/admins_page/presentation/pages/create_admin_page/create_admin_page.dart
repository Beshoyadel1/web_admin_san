import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/admins_page/presentation/widgets/custom_admin_permission_widget.dart';
import 'package:web_admin_san/feature/admins_page/view_model/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/feature/admins_page/view_model/admins_cubit/admins_state.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class CreateAdminPage extends StatelessWidget {
  const CreateAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminsCubit(),
      child: const _CreateAdminView(),
    );
  }
}

class _CreateAdminView extends StatefulWidget {
  const _CreateAdminView();

  @override
  State<_CreateAdminView> createState() => _CreateAdminViewState();
}

class _CreateAdminViewState extends State<_CreateAdminView> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final jobNameController = TextEditingController();
  final jobLatinNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final nationalityController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final Map<String, bool> permissions = {
    'statistic': false,
    'orders': false,
    'providers': false,
    'companies': false,
    'users': false,
    'finances': false,
    'packages': false,
    'approvals': false,
    'ranks': false,
    'support': false,
    'admins': false,
    'banners': false,
    'coupons': false,
    'harage': false,
    'insurance': false,
    'carBrands': false,
    'carApprovals': false,
    'warranty': false,
    'policies': false,
    'deliverySetting': false,
  };

  @override
  void dispose() {
    usernameController.dispose();
    jobNameController.dispose();
    jobLatinNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    nationalityController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = usernameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty) {
      AppSnackBar.showError(LocaleKeys.userName);
      return;
    }

    if (email.isEmpty) {
      AppSnackBar.showError(LocaleKeys.Email);
      return;
    }

    if (phone.isEmpty) {
      AppSnackBar.showError(LocaleKeys.phoneNumber);
      return;
    }

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

    final permissionRequest = AdminPermissionsRequest(
      adminid: 0,
      statistic: permissions['statistic'] ?? false,
      orders: permissions['orders'] ?? false,
      providers: permissions['providers'] ?? false,
      companies: permissions['companies'] ?? false,
      users: permissions['users'] ?? false,
      finances: permissions['finances'] ?? false,
      packages: permissions['packages'] ?? false,
      approvals: permissions['approvals'] ?? false,
      ranks: permissions['ranks'] ?? false,
      support: permissions['support'] ?? false,
      admins: permissions['admins'] ?? false,
      banners: permissions['banners'] ?? false,
      coupons: permissions['coupons'] ?? false,
      harage: permissions['harage'] ?? false,
      insurance: permissions['insurance'] ?? false,
      carBrands: permissions['carBrands'] ?? false,
      carApprovals: permissions['carApprovals'] ?? false,
      warranty: permissions['warranty'] ?? false,
      policies: permissions['policies'] ?? false,
      deliverySetting: permissions['deliverySetting'] ?? false,
    );

    final request = CreateUserRequest(
      username: username,
      phone: phone,
      email: email,
      password: password,
      gender: int.tryParse(genderController.text.trim()),
      birthDate: DateTime.tryParse(ageController.text.trim()),
      nationality: nationalityController.text.trim().isNotEmpty
          ? nationalityController.text.trim()
          : null,
      type: 6,
      isActive: true,
      adminDetails: AdminDetailsRequest(
        jobname: jobNameController.text.trim(),
        joblatinname: jobLatinNameController.text.trim(),
        permissions: permissionRequest,
      ),
    );

    context.read<AdminsCubit>().createAdmin(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TextInAppWidget(
          text: LocaleKeys.createAdmin,
          textSize: 16,
          textColor: AppColors.blackColor,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        ),
      ),
      body: BlocConsumer<AdminsCubit, AdminsState>(
        listener: (context, state) {
          if (state is AdminsCreateSuccess) {
            AppSnackBar.showSuccess(LocaleKeys.success);
            Navigator.pop(context, true);
          }
          if (state is AdminsCreateError) {
            AppSnackBar.showError(state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is AdminsCreateLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // BASIC DATA FIELDS
                  // ==========================================
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      UserTextFieldWidget(
                        controller: usernameController,
                        text: LocaleKeys.userName,
                        type: UserFieldType.name,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: jobNameController,
                        text: LocaleKeys.jobName,
                        type: UserFieldType.name,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: jobLatinNameController,
                        text: LocaleKeys.jobLatinName,
                        type: UserFieldType.name,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: phoneController,
                        text: LocaleKeys.phoneNumber,
                        type: UserFieldType.phone,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: emailController,
                        text: LocaleKeys.Email,
                        type: UserFieldType.email,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: genderController,
                        text: LocaleKeys.gender,
                        type: UserFieldType.gender,
                        readOnly: false,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: ageController,
                        text: LocaleKeys.birthDate,
                        type: UserFieldType.birthDate,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: nationalityController,
                        text: LocaleKeys.nationality,
                        type: UserFieldType.nationality,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: passwordController,
                        text: LocaleKeys.Password,
                        type: UserFieldType.password,
                        width: 260,
                      ),
                      UserTextFieldWidget(
                        controller: confirmPasswordController,
                        text: LocaleKeys.confirmPasswordKey,
                        type: UserFieldType.confirmPassword,
                        passwordControllerToMatch: passwordController,
                        width: 260,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ==========================================
                  // PERMISSIONS SECTION
                  // ==========================================
                  const TextInAppWidget(
                    text: LocaleKeys.permissionsKey,
                    textSize: 16,
                    textColor: AppColors.blackColor,
                    fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: permissions.entries.map((entry) {
                      return CustomAdminPermissionWidget(
                        permissionKey: entry.key,
                        text: _getPermissionLabel(entry.key),
                        isChecked: entry.value,
                        readOnly: false,
                        onTap: () {
                          setState(() {
                            permissions[entry.key] =
                                !(permissions[entry.key] ?? false);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // ==========================================
                  // SUBMIT BUTTON
                  // ==========================================
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : const TextInAppWidget(
                            text: LocaleKeys.create,
                            textSize: 14,
                            textColor: AppColors.whiteColor,
                            fontWeightIndex:
                                FontSelectionData.semiBoldFontFamily,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getPermissionLabel(String key) {
    switch (key) {
      case 'statistic':
        return LocaleKeys.statistics;
      case 'orders':
        return LocaleKeys.orders;
      case 'providers':
        return LocaleKeys.providers;
      case 'companies':
        return LocaleKeys.companies;
      case 'users':
        return LocaleKeys.users;
      case 'finances':
        return LocaleKeys.accountManagement;
      case 'packages':
        return LocaleKeys.packages;
      case 'approvals':
        return LocaleKeys.approvals;
      case 'ranks':
        return LocaleKeys.reviews;
      case 'support':
        return LocaleKeys.technicalSupport;
      case 'admins':
        return LocaleKeys.admins;
      case 'banners':
        return LocaleKeys.banners;
      case 'coupons':
        return LocaleKeys.coupons;
      case 'harage':
        return LocaleKeys.harage;
      case 'insurance':
        return LocaleKeys.insurance;
      case 'carBrands':
        return LocaleKeys.carsBrands;
      case 'carApprovals':
        return LocaleKeys.carApprovals;
      case 'warranty':
        return LocaleKeys.warranty;
      case 'policies':
        return LocaleKeys.socialPagesAndPoliciesKey;
      case 'deliverySetting':
        return LocaleKeys.deliverySettings;
      default:
        return key;
    }
  }
}
