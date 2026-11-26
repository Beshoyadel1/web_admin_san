import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/admins_page/presentation/widgets/custom_admin_permission_widget.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/store_page/presentation/pages/store_widgets/general_widgets_in_store/attach_file.dart';
import 'package:web_admin_san/feature/store_page/view_model/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => FacilityTabCubit()),
      ],
      child: const _UpdateProfileView(),
    );
  }
}

class _UpdateProfileView extends StatefulWidget {
  const _UpdateProfileView();

  @override
  State<_UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<_UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final jobNameController = TextEditingController();
  final jobLatinNameController = TextEditingController();
  final nationalityController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

  CreateUserRequest? _currentUser;
  bool _isLoadingUser = true;
  bool _canEditPermissions = false;

  final Map<String, bool> _permissions = {
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
    _loadInitialData();
  }

  @override
  void dispose() {
    userNameController.dispose();
    jobNameController.dispose();
    jobLatinNameController.dispose();
    nationalityController.dispose();
    ageController.dispose();
    genderController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final user = await AuthLocalStorage.getUser();
    if (!mounted) return;

    if (user != null) {
      _currentUser = user;
      userNameController.text = user.username ?? '';
      jobNameController.text = user.adminDetails?.jobname ?? '';
      jobLatinNameController.text = user.adminDetails?.joblatinname ?? '';
      nationalityController.text = user.nationality ?? '';
      ageController.text =
          OrderFunctions.formatDateFromDateTime(user.birthDate);
      genderController.text = user.gender?.toString() ?? '';

      final p = user.adminDetails?.permissions;
      if (p != null) {
        _permissions['statistic'] = p.statistic ?? false;
        _permissions['orders'] = p.orders ?? false;
        _permissions['providers'] = p.providers ?? false;
        _permissions['companies'] = p.companies ?? false;
        _permissions['users'] = p.users ?? false;
        _permissions['finances'] = p.finances ?? false;
        _permissions['packages'] = p.packages ?? false;
        _permissions['approvals'] = p.approvals ?? false;
        _permissions['ranks'] = p.ranks ?? false;
        _permissions['support'] = p.support ?? false;
        _permissions['admins'] = p.admins ?? false;
        _permissions['banners'] = p.banners ?? false;
        _permissions['coupons'] = p.coupons ?? false;
        _permissions['harage'] = p.harage ?? false;
        _permissions['insurance'] = p.insurance ?? false;
        _permissions['carBrands'] = p.carBrands ?? false;
        _permissions['carApprovals'] = p.carApprovals ?? false;
        _permissions['warranty'] = p.warranty ?? false;
        _permissions['policies'] = p.policies ?? false;
        _permissions['deliverySetting'] = p.deliverySetting ?? false;
      }

      _canEditPermissions = p?.admins == true;
    }

    setState(() {
      _isLoadingUser = false;
    });
  }

  String? _safeString(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final facilityCubit = context.read<FacilityTabCubit>();
    final user = _currentUser;
    final oldAdmin = user?.adminDetails;

    final permissionRequest = AdminPermissionsRequest(
      adminid: oldAdmin?.permissions?.adminid ?? user?.userid ?? 0,
      statistic: _permissions['statistic'] ?? false,
      orders: _permissions['orders'] ?? false,
      providers: _permissions['providers'] ?? false,
      companies: _permissions['companies'] ?? false,
      users: _permissions['users'] ?? false,
      finances: _permissions['finances'] ?? false,
      packages: _permissions['packages'] ?? false,
      approvals: _permissions['approvals'] ?? false,
      ranks: _permissions['ranks'] ?? false,
      support: _permissions['support'] ?? false,
      admins: _permissions['admins'] ?? false,
      banners: _permissions['banners'] ?? false,
      coupons: _permissions['coupons'] ?? false,
      harage: _permissions['harage'] ?? false,
      insurance: _permissions['insurance'] ?? false,
      carBrands: _permissions['carBrands'] ?? false,
      carApprovals: _permissions['carApprovals'] ?? false,
      warranty: _permissions['warranty'] ?? false,
      policies: _permissions['policies'] ?? false,
      deliverySetting: _permissions['deliverySetting'] ?? false,
    );

    final request = CreateUserRequest(
      userid: user?.userid ?? 0,
      type: user?.type,
      phone: user?.phone,
      email: user?.email,
      username: _safeString(userNameController.text) ?? user?.username,
      nationality: _safeString(nationalityController.text) ?? user?.nationality,
      birthDate: DateTime.tryParse(ageController.text.trim()) ?? user?.birthDate,
      gender: int.tryParse(genderController.text.trim()) ?? user?.gender,
      joinDate: user?.joinDate,
      isActive: user?.isActive,
      referralCode: user?.referralCode,
      fcmToken: user?.fcmToken,
      currentCarId: user?.currentCarId,
      image: facilityCubit.images['image'] ?? user?.image,
      adminDetails: AdminDetailsRequest(
        id: oldAdmin?.id,
        jobname: _safeString(jobNameController.text) ?? oldAdmin?.jobname,
        joblatinname:
            _safeString(jobLatinNameController.text) ?? oldAdmin?.joblatinname,
        permissions:
            _canEditPermissions ? permissionRequest : oldAdmin?.permissions,
      ),
    );

    context.read<AuthCubit>().updateUser(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TextInAppWidget(
          text: LocaleKeys.editProfile,
          textSize: 16,
          textColor: AppColors.blackColor,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
        ),
      ),
      body: _isLoadingUser
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthUpdateSuccess) {
                  AppSnackBar.showSuccess(LocaleKeys.success);
                  Navigator.pop(context, true);
                }
                if (state is AuthUpdateError) {
                  AppSnackBar.showError(state.error);
                }
              },
              builder: (context, state) {
                final isSaving = state is AuthUpdateLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PROFILE PICTURE SECTION
                        const AttachImage(
                          title: LocaleKeys.profilePicture,
                          type: 'image',
                          isEditMode: true,
                        ),
                        const SizedBox(height: 24),

                        // BASIC DATA FIELDS
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            UserTextFieldWidget(
                              controller: userNameController,
                              text: LocaleKeys.username,
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
                              controller: nationalityController,
                              text: LocaleKeys.nationality,
                              type: UserFieldType.nationality,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: ageController,
                              text: LocaleKeys.birthDate,
                              type: UserFieldType.birthDate,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: genderController,
                              text: LocaleKeys.gender,
                              type: UserFieldType.gender,
                              readOnly: false,
                              width: 260,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // PERMISSIONS SECTION
                        const TextInAppWidget(
                          text: LocaleKeys.permissionsKey,
                          textSize: 16,
                          textColor: AppColors.blackColor,
                          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                        ),
                        const SizedBox(height: 6),
                        if (!_canEditPermissions)
                          const TextInAppWidget(
                            text: LocaleKeys.noPermissionsAssigned,
                            textSize: 12,
                            textColor: AppColors.greyColor,
                          ),
                        const SizedBox(height: 16),

                        _UpdatePermissionsWrap(
                          permissions: _permissions,
                          canEdit: _canEditPermissions,
                          onToggle: (key) {
                            setState(() {
                              _permissions[key] = !(_permissions[key] ?? false);
                            });
                          },
                        ),
                        const SizedBox(height: 36),

                        // ACTION BUTTONS
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orangeColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isSaving ? null : _onSave,
                              child: isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                            const SizedBox(width: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.darkGreyColor,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isSaving
                                  ? null
                                  : () => Navigator.pop(context),
                              child: const TextInAppWidget(
                                text: LocaleKeys.cancel,
                                textColor: AppColors.darkColor,
                                textSize: 14,
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
}

class _UpdatePermissionsWrap extends StatelessWidget {
  final Map<String, bool> permissions;
  final bool canEdit;
  final ValueChanged<String> onToggle;

  const _UpdatePermissionsWrap({
    required this.permissions,
    required this.canEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final entries = permissions.entries.toList();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: entries.map((entry) {
        return CustomAdminPermissionWidget(
          permissionKey: entry.key,
          text: _permissionLabel(entry.key),
          isChecked: entry.value,
          readOnly: !canEdit,
          onTap: () => onToggle(entry.key),
        );
      }).toList(),
    );
  }

  String _permissionLabel(String key) {
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
