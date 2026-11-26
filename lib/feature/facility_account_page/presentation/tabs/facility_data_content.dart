import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/gender_constants.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/admins_page/presentation/widgets/custom_admin_permission_widget.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/pages/update_profile_page.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/widgets/change_email_dialog.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/widgets/change_phone_dialog.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/widgets/change_password_dialog.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';

class FacilityDataContent extends StatefulWidget {
  const FacilityDataContent({super.key});

  @override
  State<FacilityDataContent> createState() => _FacilityDataContentState();
}

class _FacilityDataContentState extends State<FacilityDataContent> {
  CreateUserRequest? _user;
  bool _isLoading = true;

  final idController = TextEditingController();
  final userNameController = TextEditingController();
  final jobNameController = TextEditingController();
  final jobLatinNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nationalityController = TextEditingController();
  final ageController = TextEditingController();
  final dateController = TextEditingController();
  final referralCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    idController.dispose();
    userNameController.dispose();
    jobNameController.dispose();
    jobLatinNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    nationalityController.dispose();
    ageController.dispose();
    dateController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await AuthLocalStorage.getUser();
    if (!mounted) return;

    if (user != null) {
      _user = user;
      idController.text = user.userid?.toString() ?? '';
      userNameController.text = user.username ?? '';
      jobNameController.text = user.adminDetails?.jobname ?? '';
      jobLatinNameController.text = user.adminDetails?.joblatinname ?? '';
      phoneController.text = user.phone ?? '';
      emailController.text = user.email ?? '';
      nationalityController.text = user.nationality ?? '';
      ageController.text = user.birthDate != null
          ? OrderFunctions.formatDateFromDateTime(user.birthDate!)
          : '';
      referralCodeController.text = user.referralCode ?? '';
      dateController.text =
          OrderFunctions.formatDateFromDateTime(user.joinDate);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _navigateToUpdate() async {
    final result = await Navigator.push(
      context,
      NavigateToPageWidget(
        const UpdateProfilePage(),
      ),
    );

    if (result == true && mounted) {
      setState(() => _isLoading = true);
      await _loadUser();
    }
  }

  void _openChangePasswordDialog() {
    final user = _user;
    final phone = user?.phone?.trim() ?? '';
    final email = user?.email?.trim() ?? '';

    if (phone.isEmpty) {
      AppSnackBar.showError(LocaleKeys.phoneNumberNotFound);
      return;
    }

    if (email.isEmpty) {
      AppSnackBar.showError(LocaleKeys.authEmailRequired);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider(
        create: (_) => AuthCubit(),
        child: ChangePasswordDialog(
          phone: phone,
          email: email,
        ),
      ),
    );
  }

  Future<void> _openChangeEmailDialog() async {
    final user = _user;
    final phone = user?.phone?.trim() ?? '';
    final email = user?.email?.trim() ?? '';

    if (phone.isEmpty) {
      AppSnackBar.showError(LocaleKeys.phoneNumberNotFound);
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider(
        create: (_) => AuthCubit(),
        child: ChangeEmailDialog(
          phone: phone,
          currentEmail: email,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() => _isLoading = true);
      await _loadUser();
    }
  }

  Future<void> _openChangePhoneDialog() async {
    final user = _user;
    final phone = user?.phone?.trim() ?? '';
    final email = user?.email?.trim() ?? '';

    if (phone.isEmpty) {
      AppSnackBar.showError(LocaleKeys.phoneNumberNotFound);
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider(
        create: (_) => AuthCubit(),
        child: ChangePhoneDialog(
          currentPhone: phone,
          currentEmail: email,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() => _isLoading = true);
      await _loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = _user;
    final isActive = user?.isActive ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================
        // HEADER SUMMARY CARD (Avatar, Name, Role, Status)
        // ======================================================
        _ProfileHeaderCard(
          user: user,
          isActive: isActive,
        ),
        const SizedBox(height: 24),

        // ======================================================
        // BASIC DATA GRID
        // ======================================================
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // USER ID (Changed from "الهوية" to "معرف المستخدم")
            UserTextFieldWidget(
              controller: idController,
              text: LocaleKeys.userId,
              type: UserFieldType.name,
              readOnly: true,
              width: 250,
            ),

            // USERNAME
            UserTextFieldWidget(
              controller: userNameController,
              text: LocaleKeys.username,
              type: UserFieldType.name,
              readOnly: true,
              width: 250,
            ),

            // JOB NAME (AR)
            UserTextFieldWidget(
              controller: jobNameController,
              text: LocaleKeys.jobName,
              type: UserFieldType.name,
              readOnly: true,
              width: 250,
            ),

            // JOB NAME (EN)
            UserTextFieldWidget(
              controller: jobLatinNameController,
              text: LocaleKeys.jobLatinName,
              type: UserFieldType.name,
              readOnly: true,
              width: 250,
            ),

            // PHONE NUMBER (uses upgraded PhoneTextField with flag)
            UserTextFieldWidget(
              controller: phoneController,
              text: LocaleKeys.phoneNumber,
              type: UserFieldType.phone,
              readOnly: true,
              width: 250,
            ),

            // EMAIL
            UserTextFieldWidget(
              controller: emailController,
              text: LocaleKeys.Email,
              type: UserFieldType.email,
              readOnly: true,
              width: 250,
            ),

            // NATIONALITY
            UserTextFieldWidget(
              controller: nationalityController,
              text: LocaleKeys.nationality,
              type: UserFieldType.nationality,
              readOnly: true,
              width: 250,
            ),

            // AGE
            UserTextFieldWidget(
              controller: ageController,
              text: LocaleKeys.birthDate,
              type: UserFieldType.normal,
              readOnly: true,
              width: 250,
            ),

            // GENDER
            UserTextFieldWidget(
              controller: TextEditingController(
                text: user?.gender.toGenderText(fallback: '-'),
              ),
              text: LocaleKeys.gender,
              type: UserFieldType.name,
              readOnly: true,
              width: 250,
            ),

            // JOINING DATE
            UserTextFieldWidget(
              controller: dateController,
              text: LocaleKeys.joiningDate,
              type: UserFieldType.name,
              readOnly: true,
              width: 250,
            ),

            // REFERRAL CODE (if present)
            if (referralCodeController.text.isNotEmpty)
              UserTextFieldWidget(
                controller: referralCodeController,
                text: LocaleKeys.referralCode,
                type: UserFieldType.name,
                readOnly: true,
                width: 250,
              ),
          ],
        ),
        const SizedBox(height: 32),

        // ======================================================
        // GRANTED PERMISSIONS SECTION
        // ======================================================
        const TextInAppWidget(
          text: LocaleKeys.grantedPermissions,
          textSize: 16,
          textColor: AppColors.blackColor,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        ),
        const SizedBox(height: 16),

        _GrantedPermissionsSection(
          permissions: user?.adminDetails?.permissions,
        ),
        const SizedBox(height: 32),

        // ======================================================
        // ACTION BUTTONS (Edit Profile, Change Password, Change Email, Change Phone)
        // ======================================================
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _navigateToUpdate,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.whiteColor,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  TextInAppWidget(
                    text: LocaleKeys.editProfile,
                    textColor: AppColors.whiteColor,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _openChangePasswordDialog,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_reset,
                    color: AppColors.whiteColor,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  TextInAppWidget(
                    text: LocaleKeys.changePassword,
                    textColor: AppColors.whiteColor,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _openChangeEmailDialog,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.alternate_email,
                    color: AppColors.whiteColor,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  TextInAppWidget(
                    text: LocaleKeys.changeEmail,
                    textColor: AppColors.whiteColor,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _openChangePhoneDialog,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_iphone_outlined,
                    color: AppColors.whiteColor,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  TextInAppWidget(
                    text: LocaleKeys.changePhone,
                    textColor: AppColors.whiteColor,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final CreateUserRequest? user;
  final bool isActive;

  const _ProfileHeaderCard({
    required this.user,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final image = user?.image;
    final displayName = user?.username ?? '-';
    final jobTitle = user?.adminDetails?.jobname ?? '';
    final jobLatin = user?.adminDetails?.joblatinname ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.lightGreyColor,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.orangeColor.withValues(alpha: 0.1),
            backgroundImage: image != null ? MemoryImage(image) : null,
            child: image == null
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.orangeColor,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextInAppWidget(
                      text: displayName,
                      textSize: 18,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.greenColor.withValues(alpha: 0.1)
                            : AppColors.redColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextInAppWidget(
                        text:
                            isActive ? LocaleKeys.active : LocaleKeys.inactive,
                        textSize: 11,
                        textColor: isActive
                            ? AppColors.greenColor
                            : AppColors.redColor,
                        fontWeightIndex: FontSelectionData.mediumFontFamily,
                      ),
                    ),
                  ],
                ),
                if (jobTitle.isNotEmpty || jobLatin.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  TextInAppWidget(
                    text: [jobTitle, jobLatin]
                        .where((e) => e.isNotEmpty)
                        .join(' | '),
                    textSize: 13,
                    textColor: AppColors.greyColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GrantedPermissionsSection extends StatelessWidget {
  final AdminPermissionsRequest? permissions;

  const _GrantedPermissionsSection({
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    if (permissions == null) {
      return const TextInAppWidget(
        text: LocaleKeys.noPermissionsAssigned,
        textSize: 13,
        textColor: AppColors.greyColor,
      );
    }

    final p = permissions!;
    final List<MapEntry<String, String>> granted = [];

    if (p.statistic == true) {
      granted.add(const MapEntry('statistic', LocaleKeys.statistics));
    }
    if (p.orders == true) {
      granted.add(const MapEntry('orders', LocaleKeys.orders));
    }
    if (p.providers == true) {
      granted.add(const MapEntry('providers', LocaleKeys.providers));
    }
    if (p.companies == true) {
      granted.add(const MapEntry('companies', LocaleKeys.companies));
    }
    if (p.users == true) {
      granted.add(const MapEntry('users', LocaleKeys.users));
    }
    if (p.finances == true) {
      granted.add(const MapEntry('finances', LocaleKeys.accountManagement));
    }
    if (p.packages == true) {
      granted.add(const MapEntry('packages', LocaleKeys.packages));
    }
    if (p.approvals == true) {
      granted.add(const MapEntry('approvals', LocaleKeys.approvals));
    }
    if (p.ranks == true) {
      granted.add(const MapEntry('ranks', LocaleKeys.reviews));
    }
    if (p.support == true) {
      granted.add(const MapEntry('support', LocaleKeys.technicalSupport));
    }
    if (p.admins == true) {
      granted.add(const MapEntry('admins', LocaleKeys.admins));
    }
    if (p.banners == true) {
      granted.add(const MapEntry('banners', LocaleKeys.banners));
    }
    if (p.coupons == true) {
      granted.add(const MapEntry('coupons', LocaleKeys.coupons));
    }
    if (p.harage == true) {
      granted.add(const MapEntry('harage', LocaleKeys.harage));
    }
    if (p.insurance == true) {
      granted.add(const MapEntry('insurance', LocaleKeys.insurance));
    }
    if (p.carBrands == true) {
      granted.add(const MapEntry('carBrands', LocaleKeys.carsBrands));
    }
    if (p.carApprovals == true) {
      granted.add(const MapEntry('carApprovals', LocaleKeys.carApprovals));
    }
    if (p.warranty == true) {
      granted.add(const MapEntry('warranty', LocaleKeys.warranty));
    }
    if (p.policies == true) {
      granted.add(
          const MapEntry('policies', LocaleKeys.socialPagesAndPoliciesKey));
    }
    if (p.deliverySetting == true) {
      granted.add(
          const MapEntry('deliverySetting', LocaleKeys.deliverySettings));
    }

    if (granted.isEmpty) {
      return const TextInAppWidget(
        text: LocaleKeys.noPermissionsAssigned,
        textSize: 13,
        textColor: AppColors.greyColor,
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: granted.map((entry) {
        return CustomAdminPermissionWidget(
          permissionKey: entry.key,
          text: entry.value,
          isChecked: true,
          readOnly: true,
        );
      }).toList(),
    );
  }
}
