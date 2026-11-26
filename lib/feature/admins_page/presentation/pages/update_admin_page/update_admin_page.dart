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
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'widgets/update_admin_password_dialog.dart';

class UpdateAdminPage extends StatelessWidget {
  final CreateUserRequest admin;

  const UpdateAdminPage({
    super.key,
    required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminsCubit(),
      child: _UpdateAdminView(admin: admin),
    );
  }
}

class _UpdateAdminView extends StatefulWidget {
  final CreateUserRequest admin;

  const _UpdateAdminView({
    required this.admin,
  });

  @override
  State<_UpdateAdminView> createState() => _UpdateAdminViewState();
}

class _UpdateAdminViewState extends State<_UpdateAdminView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController idController;
  late final TextEditingController usernameController;
  late final TextEditingController jobNameController;
  late final TextEditingController jobLatinNameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController genderController;
  late final TextEditingController ageController;
  late final TextEditingController nationalityController;

  late bool isActive;

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
  void initState() {
    super.initState();
    final a = widget.admin;
    idController = TextEditingController(text: a.userid?.toString() ?? '');
    usernameController = TextEditingController(text: a.username ?? '');
    jobNameController =
        TextEditingController(text: a.adminDetails?.jobname ?? '');
    jobLatinNameController =
        TextEditingController(text: a.adminDetails?.joblatinname ?? '');
    phoneController = TextEditingController(text: a.phone ?? '');
    emailController = TextEditingController(text: a.email ?? '');
    genderController = TextEditingController(text: a.gender?.toString() ?? '');
    ageController = TextEditingController(
        text: OrderFunctions.formatDateFromDateTime(a.birthDate));
    nationalityController = TextEditingController(text: a.nationality ?? '');
    isActive = a.isActive ?? false;

    final p = a.adminDetails?.permissions;
    if (p != null) {
      permissions['statistic'] = p.statistic ?? false;
      permissions['orders'] = p.orders ?? false;
      permissions['providers'] = p.providers ?? false;
      permissions['companies'] = p.companies ?? false;
      permissions['users'] = p.users ?? false;
      permissions['finances'] = p.finances ?? false;
      permissions['packages'] = p.packages ?? false;
      permissions['approvals'] = p.approvals ?? false;
      permissions['ranks'] = p.ranks ?? false;
      permissions['support'] = p.support ?? false;
      permissions['admins'] = p.admins ?? false;
      permissions['banners'] = p.banners ?? false;
      permissions['coupons'] = p.coupons ?? false;
      permissions['harage'] = p.harage ?? false;
      permissions['insurance'] = p.insurance ?? false;
      permissions['carBrands'] = p.carBrands ?? false;
      permissions['carApprovals'] = p.carApprovals ?? false;
      permissions['warranty'] = p.warranty ?? false;
      permissions['policies'] = p.policies ?? false;
      permissions['deliverySetting'] = p.deliverySetting ?? false;
    }
  }

  @override
  void dispose() {
    idController.dispose();
    usernameController.dispose();
    jobNameController.dispose();
    jobLatinNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    nationalityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = usernameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

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

    final admin = widget.admin;

    final permissionRequest = AdminPermissionsRequest(
      adminid: admin.userid,
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
      userid: admin.userid,
      username: username,
      phone: phone,
      email: email,
      gender: int.tryParse(genderController.text.trim()),
      birthDate:
          DateTime.tryParse(ageController.text.trim()) ?? admin.birthDate,
      type: 6,
      nationality: nationalityController.text.trim().isNotEmpty
          ? nationalityController.text.trim()
          : null,
      isActive: isActive,
      joinDate: admin.joinDate,
      referralCode: admin.referralCode,
      image: admin.image,
      fcmToken: admin.fcmToken,
      currentCarId: admin.currentCarId,
      adminDetails: AdminDetailsRequest(
        id: admin.adminDetails?.id,
        jobname: jobNameController.text.trim(),
        joblatinname: jobLatinNameController.text.trim(),
        permissions: permissionRequest,
      ),
    );

    context.read<AdminsCubit>().updateAdmin(request);
  }

  void _openChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => UpdateAdminPasswordDialog(admin: widget.admin),
    );
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
          text: LocaleKeys.edit,
          textSize: 16,
          textColor: AppColors.blackColor,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        ),
      ),
      body: BlocConsumer<AdminsCubit, AdminsState>(
        listener: (context, state) {
          if (state is AdminsUpdateSuccess) {
            AppSnackBar.showSuccess(LocaleKeys.success);
            Navigator.pop(context, true);
          }
          if (state is AdminsUpdateError) {
            AppSnackBar.showError(state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is AdminsUpdateLoading;

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
                        controller: idController,
                        text: LocaleKeys.userId,
                        type: UserFieldType.name,
                        readOnly: true,
                        width: 260,
                      ),
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
                      _AdminStatusSwitch(
                        isActive: isActive,
                        onChanged: (val) {
                          setState(() {
                            isActive = val;
                          });
                        },
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
                  // ACTION BUTTONS
                  // ==========================================
                  Row(
                    children: [
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
                                text: LocaleKeys.save,
                                textSize: 14,
                                textColor: AppColors.whiteColor,
                                fontWeightIndex:
                                    FontSelectionData.semiBoldFontFamily,
                              ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _openChangePasswordDialog,
                        icon: const Icon(
                          Icons.lock_reset,
                          color: AppColors.whiteColor,
                          size: 18,
                        ),
                        label: const TextInAppWidget(
                          text: LocaleKeys.changePassword,
                          textSize: 14,
                          textColor: AppColors.whiteColor,
                          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                        ),
                      ),
                    ],
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

class _AdminStatusSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const _AdminStatusSwitch({
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: TextInAppWidget(
            text: LocaleKeys.status,
            textSize: 14,
            textColor: AppColors.darkColor,
          ),
        ),
        Container(
          height: 35,
          width: 260,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.darkGreyColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextInAppWidget(
                text: isActive ? LocaleKeys.active : LocaleKeys.inactive,
                textSize: 13,
                textColor: isActive ? AppColors.greenColor : AppColors.redColor,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
              ),
              Switch(
                activeThumbColor: AppColors.greenColor,
                value: isActive,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
