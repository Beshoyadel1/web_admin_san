import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_state.dart';
import 'package:web_admin_san/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/providers/presentation/custom_widget/read_only_image_card.dart';

class FacilityDataContentProvider extends StatelessWidget {
  final int providerID;

  const FacilityDataContentProvider({
    super.key,
    required this.providerID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetUserInfoCubit()
        ..getUserInfo(
          request: GetUserInfoRequest(
            userId: providerID,
            userType: 4,
          ),
        ),
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
              child: BlocBuilder<GetUserInfoCubit, GetUserInfoState>(
                builder: (context, state) {
                  if (state is GetUserInfoLoading) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is GetUserInfoError) {
                    return SizedBox(
                      height: 500,
                      child: Center(
                        child: Text(state.message),
                      ),
                    );
                  }

                  if (state is GetUserInfoSuccess) {
                    final user = state.user;

                    final vatNoController = TextEditingController(
                      text: user.providerDetails?.vatno ?? '',
                    );
                    final crController = TextEditingController(
                      text: user.providerDetails?.cr ?? '',
                    );
                    final idController = TextEditingController(
                      text: user.userid?.toString() ?? '',
                    );
                    final userNameController = TextEditingController(
                      text: user.username ?? '',
                    );
                    final phoneController = TextEditingController(
                      text: user.phone ?? '',
                    );
                    final emailController = TextEditingController(
                      text: user.email ?? '',
                    );
                    final genderController = TextEditingController(
                      text: user.gander == 0 ? "Male" : "Female",
                    );
                    final ageController = TextEditingController(
                      text: user.age?.toString() ?? '',
                    );
                    final nationalAddressController = TextEditingController(
                      text: user.providerDetails?.nationaladdress ?? '',
                    );
                    final joinDateController = TextEditingController(
                      text: user.joinDate != null
                          ? OrderFunctions.formatDateFromDateTime(
                        user.joinDate!,
                      )
                          : '',
                    );

                    return Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            user.image != null
                                ? CircleAvatar(
                              radius: 20,
                              backgroundImage: MemoryImage(
                                user.image!,
                              ),
                            )
                                : const CircleAvatar(
                              radius: 20,
                            ),
                            TextInAppWidget(
                              text: user.username ?? '',
                              textSize: 15,
                              fontWeightIndex:
                              FontSelectionData.mediumFontFamily,
                              textColor: AppColors.blackColor,
                            ),
                          ],
                        ),

                        const TextInAppWidget(
                          text: AppLanguageKeys.personalData,
                          textSize: 15,
                          fontWeightIndex:
                          FontSelectionData.mediumFontFamily,
                          textColor: AppColors.orangeColor,
                        ),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            UserTextFieldWidget(
                              controller: idController,
                              text: AppLanguageKeys.identity,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: userNameController,
                              text: AppLanguageKeys.userName,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: phoneController,
                              text: AppLanguageKeys.phoneNumber,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: emailController,
                              text: AppLanguageKeys.email,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: genderController,
                              text: AppLanguageKeys.gender,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: ageController,
                              text: AppLanguageKeys.age,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: nationalAddressController,
                              text: AppLanguageKeys.branchNationalAddress,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: joinDateController,
                              text: AppLanguageKeys.joiningDate,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: vatNoController,
                              text: AppLanguageKeys.taxNumber,
                              readOnly: true,
                              width: 250,
                            ),
                            UserTextFieldWidget(
                              controller: crController,
                              text: AppLanguageKeys.commercialRecordKey,
                              readOnly: true,
                              width: 250,
                            ),
                          ],
                        ),

                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            ReadOnlyImageCard(
                              title: AppLanguageKeys.ownerIdKey,
                              image: user.image,
                            ),
                            ReadOnlyImageCard(
                              title: AppLanguageKeys.commercialRecordKey,
                              image: user.providerDetails?.crimage,
                            ),
                            ReadOnlyImageCard(
                              title: AppLanguageKeys.taxNumber,
                              image: user.providerDetails?.vatnoimage,
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
