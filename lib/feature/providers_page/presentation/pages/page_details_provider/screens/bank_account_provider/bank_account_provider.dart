import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_state.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/core/widgets/detail_section_card.dart';

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
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.orangeColor,
              ),
            ),
          );
        }

        if (state is GetUserInfoError) {
          return SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(
                      color: AppColors.redColor,
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

        if (state is GetUserInfoSuccess) {
          final user = state.user;
          final String nameText = user.providerDetails?.name ?? '';
          final String ibanText = user.providerDetails?.iban ?? '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                child: Row(
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
                            backgroundColor: AppColors.greyColor200,
                            child: Icon(
                              Icons.storefront,
                              color: AppColors.greyColor,
                            ),
                          ),
                    const SizedBox(width: 12),
                    TextInAppWidget(
                      text: user.username ?? '',
                      textSize: 16,
                      fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                      textColor: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              DetailSectionCard(
                title: LocaleKeys.bankAccount,
                icon: Icons.account_balance_outlined,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    UserTextFieldWidget(
                      initialValue: nameText,
                      text: LocaleKeys.beneficiaryNameKey,
                      readOnly: true,
                      width: 280,
                    ),
                    UserTextFieldWidget(
                      initialValue: ibanText,
                      text: LocaleKeys.ibanNumberKey,
                      readOnly: true,
                      width: 320,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
