import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/gender_constants.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/approved_centers_page/view_model/toggle_provider_approval_status_cubit/toggle_provider_approval_status_cubit.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_state.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/core/widgets/detail_section_card.dart';
import 'package:web_admin_san/feature/providers_page/presentation/widgets/read_only_image_card.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/facility_data_content_provider/provider_approval_switch.dart';

class FacilityDataContentProvider extends StatelessWidget {
  final int providerID;

  const FacilityDataContentProvider({
    super.key,
    required this.providerID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ToggleProviderApprovalStatusCubit(),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.orangeColor,
            onRefresh: () async {
              await context.read<GetUserInfoCubit>().getUserInfo(
                    request: GetUserInfoRequest(
                      userId: providerID,
                      userType: 4,
                    ),
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              child: BlocBuilder<GetUserInfoCubit, GetUserInfoState>(
                builder: (context, state) {
                  // ==================================================
                  // LOADING
                  // ==================================================
                  if (state is GetUserInfoLoading) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orangeColor,
                        ),
                      ),
                    );
                  }

                  // ==================================================
                  // ERROR
                  // ==================================================
                  if (state is GetUserInfoError) {
                    return SizedBox(
                      height: 500,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(
                                color: AppColors.darkGreyColor,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: TextButton(
                                onPressed: () {
                                  context.read<GetUserInfoCubit>().getUserInfo(
                                        request: GetUserInfoRequest(
                                          userId: providerID,
                                          userType: 4,
                                        ),
                                      );
                                },
                                child: Text(
                                  LocaleKeys.retry.tr(),
                                  style: const TextStyle(
                                    color: AppColors.orangeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ==================================================
                  // SUCCESS
                  // ==================================================
                  if (state is GetUserInfoSuccess) {
                    final user = state.user;
                    final isApproved = user.providerDetails?.isApproved == true;
                    final approval = user.providerDetails?.approvalInfo;

                    final String idText = user.userid?.toString() ?? '';
                    final String userNameText = user.username ?? '';
                    final String nationalityText = user.nationality ?? '';
                    final String phoneText = user.phone ?? '';
                    final String emailText = user.email ?? '';
                    final String genderText = user.gender.toGenderText();
                    final String ageText = user.birthDate != null
                        ? OrderFunctions.formatDateFromDateTime(user.birthDate!)
                        : '';
                    final String joinDateText = user.joinDate != null
                        ? OrderFunctions.formatDateFromDateTime(user.joinDate!)
                        : '';

                    final String facilityNameText =
                        user.providerDetails?.name ?? '';
                    final String facilityNameEnText =
                        user.providerDetails?.latinname ?? '';
                    final String crText = user.providerDetails?.cr ?? '';
                    final String vatNoText = user.providerDetails?.vatno ?? '';
                    final String nationalAddressText =
                        user.providerDetails?.nationaladdress ?? '';

                    final String approvalIdText =
                        (isApproved && approval != null)
                            ? (approval.approvalinfoid?.toString() ?? '')
                            : '';
                    final String approvalStartText =
                        (isApproved && approval?.approvalstartdate != null)
                            ? OrderFunctions.formatDateFromDateTime(
                                approval!.approvalstartdate!,
                              )
                            : '';
                    final String approvalEndText =
                        (isApproved && approval?.approvalenddate != null)
                            ? OrderFunctions.formatDateFromDateTime(
                                approval!.approvalenddate!,
                              )
                            : '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // USER HEADER CARD
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.lightGreyColor),
                          ),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 10,
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  user.image != null
                                      ? CircleAvatar(
                                          radius: 22,
                                          backgroundImage: MemoryImage(
                                            user.image!,
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 22,
                                          backgroundColor:
                                              AppColors.greyColor200,
                                          child: Icon(
                                            Icons.person,
                                            color: AppColors.greyColor,
                                          ),
                                        ),
                                  const SizedBox(width: 12),
                                  TextInAppWidget(
                                    text: user.username ?? '',
                                    textSize: 16,
                                    fontWeightIndex:
                                        FontSelectionData.semiBoldFontFamily,
                                    textColor: AppColors.blackColor,
                                  ),
                                ],
                              ),
                              ProviderApprovalSwitch(
                                providerId: providerID,
                                isApproved: isApproved,
                              ),
                            ],
                          ),
                        ),

                        // PERSONAL DATA CARD
                        DetailSectionCard(
                          title: LocaleKeys.personalData,
                          icon: Icons.person_outline_rounded,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              UserTextFieldWidget(
                                initialValue: idText,
                                text: LocaleKeys.identity,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: userNameText,
                                text: LocaleKeys.userName,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: nationalityText,
                                text: LocaleKeys.nationality,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: phoneText,
                                text: LocaleKeys.phoneNumber,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: emailText,
                                text: LocaleKeys.Email,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: ageText,
                                text: LocaleKeys.birthDate,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: genderText,
                                text: LocaleKeys.gender,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: joinDateText,
                                text: LocaleKeys.joiningDate,
                                readOnly: true,
                                width: 260,
                              ),
                            ],
                          ),
                        ),

                        // FACILITY DATA CARD
                        DetailSectionCard(
                          title: LocaleKeys.facilityData,
                          icon: Icons.business_outlined,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              UserTextFieldWidget(
                                initialValue: facilityNameText,
                                text: LocaleKeys.facilityName,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: facilityNameEnText,
                                text: LocaleKeys.facilityNameEn,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: crText,
                                text: LocaleKeys.commercialRecordKey,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: vatNoText,
                                text: LocaleKeys.taxNumber,
                                readOnly: true,
                                width: 260,
                              ),
                              UserTextFieldWidget(
                                initialValue: nationalAddressText,
                                text: LocaleKeys.branchNationalAddress,
                                readOnly: true,
                                width: 260,
                              ),
                            ],
                          ),
                        ),

                        // APPROVAL INFORMATION CARD
                        if (isApproved)
                          DetailSectionCard(
                            title: LocaleKeys.approvalInfo,
                            icon: Icons.verified_outlined,
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                UserTextFieldWidget(
                                  initialValue: approvalIdText,
                                  text: LocaleKeys.approvalInfoId,
                                  readOnly: true,
                                  width: 260,
                                ),
                                UserTextFieldWidget(
                                  initialValue: approvalStartText,
                                  text: LocaleKeys.approvalStartDate,
                                  readOnly: true,
                                  width: 260,
                                ),
                                UserTextFieldWidget(
                                  initialValue: approvalEndText,
                                  text: LocaleKeys.approvalEndDate,
                                  readOnly: true,
                                  width: 260,
                                ),
                              ],
                            ),
                          ),

                        // DOCUMENTS CARD
                        DetailSectionCard(
                          title: LocaleKeys.documents,
                          icon: Icons.folder_shared_outlined,
                          child: Wrap(
                            spacing: 24,
                            runSpacing: 20,
                            children: [
                              ReadOnlyImageCard(
                                title: LocaleKeys.ownerIdKey,
                                image: user.image,
                              ),
                              ReadOnlyImageCard(
                                title: LocaleKeys.commercialRecordKey,
                                image: user.providerDetails?.crimage,
                              ),
                              ReadOnlyImageCard(
                                title: LocaleKeys.taxNumber,
                                image: user.providerDetails?.vatnoimage,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
