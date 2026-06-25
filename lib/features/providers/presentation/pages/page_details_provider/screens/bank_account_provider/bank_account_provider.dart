import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/features/auth_page/presentation/bloc/get_user_info_cubit/get_user_info_state.dart';
import 'package:web_admin_san/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/features/internal_services/presentation/cubit/order_funcations/order_functions.dart';
import 'package:web_admin_san/features/providers/presentation/custom_widget/read_only_image_card.dart';

class BankAccountProvider extends StatelessWidget {
  final int providerID;

  const BankAccountProvider({
    super.key,
    required this.providerID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserInfoCubit, GetUserInfoState>(
      builder: (context, state) {
        if (state is GetUserInfoLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetUserInfoError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is GetUserInfoSuccess) {
          final user = state.user;

          final nameController = TextEditingController(
            text: user.providerDetails?.name ?? '',
          );
          final ibanController = TextEditingController(
            text: user.providerDetails?.iban ?? '',
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
                    controller: nameController,
                    text: AppLanguageKeys.beneficiaryNameKey,
                    readOnly: true,
                    width: 250,
                  ),
                  UserTextFieldWidget(
                    controller: ibanController,
                    text: AppLanguageKeys.ibanNumberKey,
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