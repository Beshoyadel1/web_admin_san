import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/approved_centers/presentation/bloc/toggle_provider_approval_status_cubit/toggle_provider_approval_status_cubit.dart';
import 'package:web_admin_san/features/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_state.dart';
import 'package:web_admin_san/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/providers/presentation/custom_widget/read_only_image_card.dart';
import 'package:web_admin_san/features/providers/presentation/pages/page_details_provider/screens/facility_data_content_provider/provider_approval_switch.dart';

class FacilityDataContentProvider extends StatefulWidget {
  final int providerID;

  const FacilityDataContentProvider({
    super.key,
    required this.providerID,
  });

  @override
  State<FacilityDataContentProvider> createState() =>
      _FacilityDataContentProviderState();
}

class _FacilityDataContentProviderState
    extends State<FacilityDataContentProvider> {

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final idController =
  TextEditingController();

  final userNameController =
  TextEditingController();

  final nationalityController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final genderController =
  TextEditingController();

  final ageController =
  TextEditingController();

  final joinDateController =
  TextEditingController();

  final facilityNameController =
  TextEditingController();

  final facilityNameEnController =
  TextEditingController();

  final crController =
  TextEditingController();

  final vatNoController =
  TextEditingController();

  final nationalAddressController =
  TextEditingController();

  final approvalIdController =
  TextEditingController();

  final approvalStartDateController =
  TextEditingController();

  final approvalEndDateController =
  TextEditingController();

  // ============================================================
  // UPDATE CONTROLLERS
  // ============================================================

  void _setUserData(dynamic user) {
    idController.text =
        user.userid?.toString() ?? '';

    userNameController.text =
        user.username ?? '';

    nationalityController.text =
        user.nationality ?? '';

    phoneController.text =
        user.phone ?? '';

    emailController.text =
        user.email ?? '';

    genderController.text =
    user.gender == 0
        ? AppLanguageKeys.male
        : AppLanguageKeys.female;

    ageController.text =
        user.age?.toString() ?? '';

    joinDateController.text =
    user.joinDate != null
        ? OrderFunctions.formatDateFromDateTime(
      user.joinDate!,
    )
        : '';

    // ==========================================================
    // PROVIDER DATA
    // ==========================================================

    facilityNameController.text =
        user.providerDetails?.name ?? '';

    facilityNameEnController.text =
        user.providerDetails?.latinname ?? '';

    crController.text =
        user.providerDetails?.cr ?? '';

    vatNoController.text =
        user.providerDetails?.vatno ?? '';

    nationalAddressController.text =
        user.providerDetails?.nationaladdress ?? '';

    // ==========================================================
    // APPROVAL DATA
    // ==========================================================

    final approval =
        user.providerDetails?.approvalInfo;

    if (user.providerDetails?.isApproved == true &&
        approval != null) {

      approvalIdController.text =
          approval.approvalinfoid?.toString() ?? '';

      approvalStartDateController.text =
      approval.approvalstartdate != null
          ? OrderFunctions.formatDateFromDateTime(
        approval.approvalstartdate!,
      )
          : '';

      approvalEndDateController.text =
      approval.approvalenddate != null
          ? OrderFunctions.formatDateFromDateTime(
        approval.approvalenddate!,
      )
          : '';
    } else {
      approvalIdController.clear();
      approvalStartDateController.clear();
      approvalEndDateController.clear();
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    idController.dispose();
    userNameController.dispose();
    nationalityController.dispose();
    phoneController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    joinDateController.dispose();
    facilityNameController.dispose();
    facilityNameEnController.dispose();
    crController.dispose();
    vatNoController.dispose();
    nationalAddressController.dispose();
    approvalIdController.dispose();
    approvalStartDateController.dispose();
    approvalEndDateController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          GetUserInfoCubit()
            ..getUserInfo(
              request: GetUserInfoRequest(
                userId: widget.providerID,
                userType: 4,
              ),
            ),
        ),

        BlocProvider(
          create: (_) =>
              ToggleProviderApprovalStatusCubit(),
        ),
      ],

      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.orangeColor,

            onRefresh: () async {
              await context
                  .read<GetUserInfoCubit>()
                  .getUserInfo(
                request: GetUserInfoRequest(
                  userId: widget.providerID,
                  userType: 4,
                ),
              );
            },

            child: SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding:
              const EdgeInsets.only(
                bottom: 20,
              ),

              child:
              BlocConsumer<
                  GetUserInfoCubit,
                  GetUserInfoState
              >(
                listener: (context, state) {
                  if (state
                  is GetUserInfoSuccess) {
                    _setUserData(
                      state.user,
                    );
                  }
                },

                builder: (
                    context,
                    state,
                    ) {
                  // ==================================================
                  // LOADING
                  // ==================================================

                  if (state
                  is GetUserInfoLoading) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                    );
                  }

                  // ==================================================
                  // ERROR
                  // ==================================================

                  if (state
                  is GetUserInfoError) {
                    return SizedBox(
                      height: 500,
                      child: Center(
                        child: Text(
                          state.message,
                        ),
                      ),
                    );
                  }

                  // ==================================================
                  // SUCCESS
                  // ==================================================

                  if (state
                  is GetUserInfoSuccess) {
                    final user =
                        state.user;

                    final isApproved =
                        user.providerDetails
                            ?.isApproved ==
                            true;

                    return Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        // ==================================================
                        // USER HEADER
                        // ==================================================

                        Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          crossAxisAlignment:
                          WrapCrossAlignment.center,

                          children: [

                            // ----------------------------------------------
                            // USER IMAGE + NAME
                            // ----------------------------------------------

                            Wrap(
                              spacing: 10,
                              crossAxisAlignment:
                              WrapCrossAlignment.center,

                              children: [

                                user.image !=
                                    null
                                    ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                  MemoryImage(
                                    user.image!,
                                  ),
                                )
                                    : const CircleAvatar(
                                  radius: 20,
                                ),

                                TextInAppWidget(
                                  text:
                                  user.username ??
                                      '',
                                  textSize:
                                  15,
                                  fontWeightIndex:
                                  FontSelectionData
                                      .mediumFontFamily,
                                  textColor:
                                  AppColors
                                      .blackColor,
                                ),
                              ],
                            ),

                            // ----------------------------------------------
                            // APPROVAL SWITCH
                            // ----------------------------------------------

                            ProviderApprovalSwitch(
                              providerId:
                              widget.providerID,
                              isApproved:
                              isApproved,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // ==================================================
                        // PERSONAL DATA
                        // ==================================================

                        const TextInAppWidget(
                          text:
                          AppLanguageKeys
                              .personalData,
                          textSize: 15,
                          fontWeightIndex:
                          FontSelectionData
                              .mediumFontFamily,
                          textColor:
                          AppColors
                              .orangeColor,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,

                          children: [

                            // ----------------------------------------------
                            // ID
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              idController,
                              text:
                              AppLanguageKeys
                                  .identity,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // USERNAME
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              userNameController,
                              text:
                              AppLanguageKeys
                                  .userName,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // NATIONALITY
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              nationalityController,
                              text:
                              AppLanguageKeys
                                  .nationality,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // PHONE
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              phoneController,
                              text:
                              AppLanguageKeys
                                  .phoneNumber,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // EMAIL
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              emailController,
                              text:
                              AppLanguageKeys
                                  .email,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // AGE
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              ageController,
                              text:
                              AppLanguageKeys
                                  .age,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // GENDER
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              genderController,
                              text:
                              AppLanguageKeys
                                  .gender,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // JOIN DATE
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              joinDateController,
                              text:
                              AppLanguageKeys
                                  .joiningDate,
                              readOnly:
                              true,
                              width:
                              250,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // ==================================================
                        // FACILITY DATA
                        // ==================================================

                        const TextInAppWidget(
                          text:
                          AppLanguageKeys
                              .facilityData,
                          textSize: 15,
                          fontWeightIndex:
                          FontSelectionData
                              .mediumFontFamily,
                          textColor:
                          AppColors
                              .orangeColor,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,

                          children: [

                            // ----------------------------------------------
                            // FACILITY NAME
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              facilityNameController,
                              text:
                              AppLanguageKeys
                                  .facilityName,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // FACILITY NAME EN
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              facilityNameEnController,
                              text:
                              AppLanguageKeys
                                  .facilityNameEn,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // COMMERCIAL RECORD
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              crController,
                              text:
                              AppLanguageKeys
                                  .commercialRecordKey,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // VAT
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              vatNoController,
                              text:
                              AppLanguageKeys
                                  .taxNumber,
                              readOnly:
                              true,
                              width:
                              250,
                            ),

                            // ----------------------------------------------
                            // NATIONAL ADDRESS
                            // ----------------------------------------------

                            UserTextFieldWidget(
                              controller:
                              nationalAddressController,
                              text:
                              AppLanguageKeys
                                  .branchNationalAddress,
                              readOnly:
                              true,
                              width:
                              250,
                            ),
                          ],
                        ),

                        // ==================================================
                        // APPROVAL INFORMATION
                        // ==================================================

                        if (isApproved) ...[
                          const SizedBox(
                            height: 20,
                          ),

                          const TextInAppWidget(
                            text:
                            AppLanguageKeys
                                .approvalInfo,
                            textSize: 15,
                            fontWeightIndex:
                            FontSelectionData
                                .mediumFontFamily,
                            textColor:
                            AppColors
                                .orangeColor,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,

                            children: [

                              // --------------------------------------------
                              // APPROVAL ID
                              // --------------------------------------------

                              UserTextFieldWidget(
                                controller:
                                approvalIdController,
                                text:
                                AppLanguageKeys
                                    .approvalInfoId,
                                readOnly:
                                true,
                                width:
                                250,
                              ),

                              // --------------------------------------------
                              // START DATE
                              // --------------------------------------------

                              UserTextFieldWidget(
                                controller:
                                approvalStartDateController,
                                text:
                                AppLanguageKeys
                                    .approvalStartDate,
                                readOnly:
                                true,
                                width:
                                250,
                              ),

                              // --------------------------------------------
                              // END DATE
                              // --------------------------------------------

                              UserTextFieldWidget(
                                controller:
                                approvalEndDateController,
                                text:
                                AppLanguageKeys
                                    .approvalEndDate,
                                readOnly:
                                true,
                                width:
                                250,
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(
                          height: 20,
                        ),

                        // ==================================================
                        // DOCUMENTS
                        // ==================================================

                        const TextInAppWidget(
                          text:
                          AppLanguageKeys
                              .documents,
                          textSize: 15,
                          fontWeightIndex:
                          FontSelectionData
                              .mediumFontFamily,
                          textColor:
                          AppColors
                              .orangeColor,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Wrap(
                          spacing: 20,
                          runSpacing: 20,

                          children: [

                            // ----------------------------------------------
                            // OWNER / PROFILE
                            // ----------------------------------------------

                            ReadOnlyImageCard(
                              title:
                              AppLanguageKeys
                                  .ownerIdKey,
                              image:
                              user.image,
                            ),

                            // ----------------------------------------------
                            // COMMERCIAL RECORD
                            // ----------------------------------------------

                            ReadOnlyImageCard(
                              title:
                              AppLanguageKeys
                                  .commercialRecordKey,
                              image:
                              user.providerDetails
                                  ?.crimage,
                            ),

                            // ----------------------------------------------
                            // TAX NUMBER
                            // ----------------------------------------------

                            ReadOnlyImageCard(
                              title:
                              AppLanguageKeys
                                  .taxNumber,
                              image:
                              user.providerDetails
                                  ?.vatnoimage,
                            ),
                          ],
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