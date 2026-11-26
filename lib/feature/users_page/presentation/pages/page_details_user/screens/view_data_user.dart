import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/gender_constants.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/feature/internal_services/view_model/order_functions/order_functions.dart';
import 'package:web_admin_san/feature/users_page/view_model/user_details_cubit/user_details_cubit.dart';
import 'package:web_admin_san/feature/users_page/view_model/user_details_cubit/user_details_state.dart';

class ViewDataUser extends StatelessWidget {
  const ViewDataUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsCubit, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsSuccess) {
          final user = state.data.userInfo;
          final id = user.userId.toString();
          final userName = user.userName;
          final phone = user.phone;
          final email = user.email;
          final gender = user.gender.toGenderText();
          final birthDate =
              OrderFunctions.formatDateFromDateTime(user.birthDate);
          final age = user.age > 0 ? '${user.age}' : '-';
          final nationality =
              user.nationality.isNotEmpty ? user.nationality : '-';
          final nationalAddress = user.nationalAddress ?? '-';
          final joinDate = OrderFunctions.formatDateFromDateTime(user.joinDate);
          final status = user.isActive == true
              ? LocaleKeys.active.tr()
              : LocaleKeys.inactive.tr();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  user.image != null
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage: MemoryImage(
                            user.image!,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.lightOrangeColor,
                          child: Icon(
                            Icons.person,
                            color: AppColors.orangeColor,
                          ),
                        ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInAppWidget(
                        text: user.userName,
                        textSize: 16,
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                      const SizedBox(height: 2),
                      TextInAppWidget(
                        text: '#${user.userId}',
                        textSize: 13,
                        textColor: AppColors.greyColor,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const TextInAppWidget(
                text: LocaleKeys.personalData,
                textSize: 15,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.orangeColor,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  UserTextFieldWidget(
                    text: LocaleKeys.identity,
                    initialValue: id,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.userName,
                    initialValue: userName,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.phoneNumber,
                    initialValue: phone,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.Email,
                    initialValue: email,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.gender,
                    initialValue: gender,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.birthDate,
                    initialValue: birthDate,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.age,
                    initialValue: age,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.nationality,
                    initialValue: nationality,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.branchNationalAddress,
                    initialValue: nationalAddress,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.joiningDate,
                    initialValue: joinDate,
                    readOnly: true,
                    width: 260,
                  ),
                  UserTextFieldWidget(
                    text: LocaleKeys.status,
                    initialValue: status,
                    readOnly: true,
                    width: 260,
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
