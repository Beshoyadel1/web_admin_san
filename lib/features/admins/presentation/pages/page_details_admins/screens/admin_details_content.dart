import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_cubit.dart';
import 'package:web_admin_san/features/admins/presentation/bloc/admins_cubit/admins_state.dart';
import 'package:web_admin_san/features/admins/presentation/custom_widget/custom_admin_permission_widget.dart';

import 'package:web_admin_san/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/admin_details_request.dart';

import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_state.dart';


import 'package:web_admin_san/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

class AdminDetailsContent extends StatefulWidget {
  const AdminDetailsContent({
    super.key,
  });

  @override
  State<AdminDetailsContent> createState() =>
      _AdminDetailsContentState();
}

class _AdminDetailsContentState
    extends State<AdminDetailsContent> {

  bool isEditMode = false;

  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final jobNameController = TextEditingController();
  final jobLatinNameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();

  CreateUserRequest? originalAdmin;

  // ============================================================
  // PERMISSIONS
  // ============================================================

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
  };

  @override
  void dispose() {
    idController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    jobNameController.dispose();
    jobLatinNameController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD ADMIN
  // ============================================================

  void _loadAdmin(CreateUserRequest admin) {
    originalAdmin = admin;
    idController.text=admin.userid.toString();

    usernameController.text =
        admin.username ?? '';

    phoneController.text =
        admin.phone ?? '';

    emailController.text =
        admin.email ?? '';

    genderController.text =
        admin.gender?.toString() ?? '';

    ageController.text =
        admin.age?.toString() ?? '';

    jobNameController.text =
        admin.adminDetails?.jobname ?? '';

    jobLatinNameController.text =
        admin.adminDetails?.joblatinname ?? '';

    final p = admin.adminDetails?.permissions;

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
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  void _updateAdmin() {
    final admin = originalAdmin;

    if (admin == null) return;

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
    );

    final request = CreateUserRequest(
      userid: admin.userid,

      username: usernameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),

      gender: int.tryParse(
        genderController.text.trim(),
      ),

      age: int.tryParse(
        ageController.text.trim(),
      ),

      type: 6,

      nationality: admin.nationality,
      isActive: admin.isActive,
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

    debugPrint(
        '========== ADMIN UPDATE REQUEST =========='
    );

    debugPrint(
      jsonEncode(
        request.toJson(),
      ),
    );

    context.read<AdminsCubit>().updateAdmin(
      request,
    );
  }

  // ============================================================
  // CANCEL
  // ============================================================

  void _cancelEdit() {
    final admin = originalAdmin;

    if (admin == null) return;

    _loadAdmin(admin);

    setState(() {
      isEditMode = false;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return  MultiBlocListener(
      listeners: [

        // ================= GET ADMIN =================

        BlocListener<GetUserInfoCubit, GetUserInfoState>(
          listener: (context, state) {
            if (state is GetUserInfoSuccess) {
              setState(() {
                _loadAdmin(state.user);
              });
            }

            if (state is GetUserInfoError) {
              AppSnackBar.showError(
                state.message,
              );
            }
          },
        ),

        // ================= UPDATE ADMIN =================

        BlocListener<AdminsCubit, AdminsState>(
          listener: (context, state) {

            if (state is AdminsUpdateSuccess) {
              AppSnackBar.showSuccess(
                AppLanguageKeys.success,
              );

              setState(() {
                isEditMode = false;
              });

              // Optional:
              // reload admin after update
              // context.read<GetUserInfoCubit>().getUserInfo(...);
            }

            if (state is AdminsUpdateError) {
              AppSnackBar.showError(
                state.error,
              );
            }
          },
        ),
      ],

      child: BlocBuilder<GetUserInfoCubit, GetUserInfoState>(
        builder: (context, state) {

          if (state is GetUserInfoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetUserInfoError) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          }

          if (state is GetUserInfoSuccess) {
            final isUpdating =
            context.watch<AdminsCubit>().state
            is AdminsUpdateLoading;

            return _buildContent(
              isUpdating,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Form(
        key: _formKey,

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // ==================================================
            // BASIC DATA
            // ==================================================

            Wrap(
              spacing: 10,
              runSpacing: 15,

              children: [
                UserTextFieldWidget(
                  controller: idController,
                  text: AppLanguageKeys.identity,
                  type: UserFieldType.name,
                  readOnly: true,
                  width: 250,
                ),
                UserTextFieldWidget(
                  controller: usernameController,
                  text: AppLanguageKeys.userName,
                  type: UserFieldType.name,
                  readOnly: !isEditMode,
                  width: 250,
                ),

                UserTextFieldWidget(
                  controller: jobNameController,
                  text: AppLanguageKeys.jobName,
                  type: UserFieldType.name,
                  readOnly: !isEditMode,
                  width: 250,
                ),

                UserTextFieldWidget(
                  controller: jobLatinNameController,
                  text: AppLanguageKeys.jobLatinName,
                  type: UserFieldType.name,
                  readOnly: !isEditMode,
                  width: 250,
                ),

                UserTextFieldWidget(
                  controller: phoneController,
                  text: AppLanguageKeys.phoneNumber,
                  type: UserFieldType.phone,
                  readOnly: !isEditMode,
                  width: 250,
                ),

                UserTextFieldWidget(
                  controller: emailController,
                  text: AppLanguageKeys.email,
                  type: UserFieldType.email,
                  readOnly: !isEditMode,
                  width: 250,
                ),

                UserTextFieldWidget(
                  controller: genderController,
                  text: AppLanguageKeys.gender,
                  type: UserFieldType.gender,
                  readOnly: !isEditMode,
                  width: 250,
                ),

                UserTextFieldWidget(
                  controller: ageController,
                  text: AppLanguageKeys.age,
                  type: UserFieldType.number,
                  readOnly: !isEditMode,
                  width: 250,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==================================================
            // PERMISSIONS TITLE
            // ==================================================

            const TextInAppWidget(
              text: AppLanguageKeys.permissionsKey,
              textSize: 16,
              textColor: AppColors.blackColor,
            ),

            const SizedBox(height: 15),

            // ==================================================
            // PERMISSIONS
            // ==================================================

            _buildPermissions(),

            const SizedBox(height: 30),

            // ==================================================
            // BUTTONS
            // ==================================================

            Row(
              children: [

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.orangeColor,
                  ),

                  onPressed: isLoading
                      ? null
                      : () {

                    // VIEW -> EDIT
                    if (!isEditMode) {
                      setState(() {
                        isEditMode = true;
                      });
                      return;
                    }

                    // EDIT -> SAVE
                    _updateAdmin();
                  },

                  child: isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : TextInAppWidget(
                    text: isEditMode
                        ? AppLanguageKeys.save
                        : AppLanguageKeys.edit,
                    textSize: 13,
                    textColor:
                    AppColors.whiteColor,
                  ),
                ),

                const SizedBox(width: 10),

                if (isEditMode)
                  ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.orangeColor,
                    ),

                    onPressed: _cancelEdit,

                    child:
                    const TextInAppWidget(
                      text:
                      AppLanguageKeys.cancel,
                      textSize: 13,
                      textColor:
                      AppColors.whiteColor,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PERMISSIONS UI
  // ============================================================

  Widget _buildPermissions() {
    final entries = permissions.entries.toList();

    final visiblePermissions = isEditMode
        ? entries
        : entries.where((entry) => entry.value).toList();

    if (visiblePermissions.isEmpty) {
      return const TextInAppWidget(
        text: AppLanguageKeys.noPermissionsAssigned,
        textSize: 13,
        textColor: AppColors.greyColor,
      );
    }

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: visiblePermissions.map((entry) {
        return CustomAdminPermissionWidget(
          permissionKey: entry.key,
          text: _permissionName(entry.key),
          isChecked: entry.value,
          readOnly: !isEditMode,
          onTap: () {
            if (!isEditMode) return;

            setState(() {
              permissions[entry.key] =
              !(permissions[entry.key] ?? false);
            });
          },
        );
      }).toList(),
    );
  }
  String _permissionName(String key) {
    switch (key) {
      case 'statistic':
        return AppLanguageKeys.statistics;

      case 'orders':
        return AppLanguageKeys.orders;

      case 'providers':
        return AppLanguageKeys.providers;

      case 'companies':
        return AppLanguageKeys.companies;

      case 'users':
        return AppLanguageKeys.users;

      case 'finances':
        return AppLanguageKeys.finances;

      case 'packages':
        return AppLanguageKeys.packages;

      case 'approvals':
        return AppLanguageKeys.approvals;

      case 'ranks':
        return AppLanguageKeys.ranks;

      case 'support':
        return AppLanguageKeys.support;

      case 'admins':
        return AppLanguageKeys.admins;

      case 'banners':
        return AppLanguageKeys.banners;

      case 'coupons':
        return AppLanguageKeys.coupons;

      case 'harage':
        return AppLanguageKeys.harage;

      case 'insurance':
        return AppLanguageKeys.insurance;

      default:
        return key;
    }
  }
}