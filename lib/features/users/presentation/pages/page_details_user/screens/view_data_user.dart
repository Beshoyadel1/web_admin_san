import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/features/users/presentation/bloc/user_details_cubit/user_details_state.dart';

class ViewDataUser extends StatelessWidget {
  const ViewDataUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsCubit, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is UserDetailsFailure) {
          return Center(
            child: Text(state.error),
          );
        }

        if (state is UserDetailsSuccess) {

          final user = state.data.userInfo;

          final idController = TextEditingController(
            text: user.userId.toString(),
          );

          final userNameController = TextEditingController(
            text: user.userName,
          );

          final phoneController = TextEditingController(
            text: user.phone,
          );

          final emailController = TextEditingController(
            text: user.email,
          );

          final genderController = TextEditingController(
            text: user.gender == 0 ? "Male" : "Female",
          );

          final ageController = TextEditingController(
            text: user.age.toString(),
          );

          final nationalAddressController = TextEditingController(
            text: user.nationalAddress ?? '',
          );

          final joinDateController = TextEditingController(
            text: OrderFunctions.formatDateFromDateTime(
              user.joinDate,
            ),
          );

          return Column(
            spacing: 30,
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
                    text: user.userName,
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                ],
              ),

              const TextInAppWidget(
                text: AppLanguageKeys.personalData,
                textSize: 15,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
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
                ],
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
