import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/admins_page/presentation/pages/update_admin_page/update_admin_page.dart';
import 'package:web_admin_san/feature/admins_page/presentation/widgets/custom_admin_permission_widget.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_state.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class AdminDetailsContent extends StatefulWidget {
  final int adminId;

  const AdminDetailsContent({
    super.key,
    required this.adminId,
  });

  @override
  State<AdminDetailsContent> createState() => _AdminDetailsContentState();
}

class _AdminDetailsContentState extends State<AdminDetailsContent> {
  CreateUserRequest? _currentAdmin;

  Future<void> _navigateToUpdate(CreateUserRequest admin) async {
    final result = await Navigator.push(
      context,
      NavigateToPageWidget(
        UpdateAdminPage(admin: admin),
      ),
    );

    if (result == true && mounted) {
      context.read<GetUserInfoCubit>().getUserInfo(
            request: GetUserInfoRequest(
              userId: widget.adminId,
              userType: 6,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetUserInfoCubit, GetUserInfoState>(
      listener: (context, state) {
        if (state is GetUserInfoSuccess) {
          setState(() {
            _currentAdmin = state.user;
          });
        }
      },
      builder: (context, state) {
        if (state is GetUserInfoLoading && _currentAdmin == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetUserInfoError && _currentAdmin == null) {
          return Center(
            child: TextInAppWidget(
              text: state.message,
              textSize: 14,
              textColor: AppColors.redColor,
            ),
          );
        }

        final admin =
            _currentAdmin ?? (state is GetUserInfoSuccess ? state.user : null);

        if (admin == null) {
          return const SizedBox();
        }

        final isActive = admin.isActive ?? false;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // BASIC DATA FIELDS (READ-ONLY)
              // ==========================================
              Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: admin.userid?.toString() ?? '',
                    ),
                    text: LocaleKeys.userId,
                    type: UserFieldType.name,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: admin.username ?? '',
                    ),
                    text: LocaleKeys.userName,
                    type: UserFieldType.name,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: admin.adminDetails?.jobname ?? '',
                    ),
                    text: LocaleKeys.jobName,
                    type: UserFieldType.name,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: admin.adminDetails?.joblatinname ?? '',
                    ),
                    text: LocaleKeys.jobLatinName,
                    type: UserFieldType.name,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: admin.phone ?? '',
                    ),
                    text: LocaleKeys.phoneNumber,
                    type: UserFieldType.phone,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: admin.email ?? '',
                    ),
                    text: LocaleKeys.Email,
                    type: UserFieldType.email,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: OrderFunctions.getGenderText(admin.gender, context),
                    ),
                    text: LocaleKeys.gender,
                    type: UserFieldType.name,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: OrderFunctions.formatDateFromDateTime(
                          admin.birthDate),
                    ),
                    text: LocaleKeys.birthDate,
                    type: UserFieldType.normal,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: admin.nationality ?? '',
                    ),
                    text: LocaleKeys.nationality,
                    type: UserFieldType.name,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: TextEditingController(
                      text: OrderFunctions.formatDateFromDateTime(
                        admin.joinDate,
                      ),
                    ),
                    text: LocaleKeys.joiningDate,
                    type: UserFieldType.name,
                    readOnly: true,
                    width: 250,
                  ),
                  _AdminStatusBadge(
                    isActive: isActive,
                    width: 250,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ==========================================
              // GRANTED PERMISSIONS SECTION
              // ==========================================
              const TextInAppWidget(
                text: LocaleKeys.grantedPermissions,
                textSize: 16,
                textColor: AppColors.blackColor,
                fontWeightIndex: FontSelectionData.semiBoldFontFamily,
              ),
              const SizedBox(height: 16),

              _AdminGrantedPermissionsView(
                permissions: admin.adminDetails?.permissions,
              ),
              const SizedBox(height: 32),

              // ==========================================
              // ACTION BUTTON (EDIT)
              // ==========================================
              ElevatedButton.icon(
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
                onPressed: () => _navigateToUpdate(admin),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.whiteColor,
                  size: 18,
                ),
                label: const TextInAppWidget(
                  text: LocaleKeys.edit,
                  textSize: 14,
                  textColor: AppColors.whiteColor,
                  fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminStatusBadge extends StatelessWidget {
  final bool isActive;
  final double? width;

  const _AdminStatusBadge({
    required this.isActive,
    this.width = 250,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return SizedBox(
      width: isMobile ? double.infinity : (width ?? 250),
      child: Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.darkGreyColor,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.greenColor : AppColors.redColor,
                  ),
                ),
                const SizedBox(width: 8),
                TextInAppWidget(
                  text: isActive ? LocaleKeys.active : LocaleKeys.inactive,
                  textSize: 13,
                  textColor:
                      isActive ? AppColors.greenColor : AppColors.redColor,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminGrantedPermissionsView extends StatelessWidget {
  final AdminPermissionsRequest? permissions;

  const _AdminGrantedPermissionsView({
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
      granted
          .add(const MapEntry('deliverySetting', LocaleKeys.deliverySettings));
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
