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
import 'package:web_admin_san/feature/providers_page/presentation/widgets/read_only_image_card.dart';

class ContentCompanies extends StatelessWidget {
  final int company;

  const ContentCompanies({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.orangeColor,
      onRefresh: () async {
        await context.read<GetUserInfoCubit>().getUserInfo(
              request: GetUserInfoRequest(
                userId: company,
                userType: 2,
              ),
            );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: BlocBuilder<GetUserInfoCubit, GetUserInfoState>(
              builder: (context, state) {
                if (state is GetUserInfoLoading) {
                  return const SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orangeColor,
                      ),
                    ),
                  );
                }

                if (state is GetUserInfoError) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                      child: TextInAppWidget(
                        text: state.message,
                        textSize: 14,
                        textColor: AppColors.redColor,
                        fontWeightIndex: FontSelectionData.mediumFontFamily,
                      ),
                    ),
                  );
                }

                if (state is GetUserInfoSuccess) {
                  final user = state.user;
                  final companyNameAr =
                      user.companyDetails?.name ?? user.username ?? '';
                  final companyNameEn = user.companyDetails?.latinname ?? '';
                  final phone = user.phone ?? '';
                  final email = user.email ?? '';
                  final cr = user.companyDetails?.cr ?? '';
                  final vatNo = user.companyDetails?.vatno ?? '';
                  final id = user.userid?.toString() ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ==================================================
                      // COMPANY HEADER CARD
                      // ==================================================
                      CompanyHeaderCard(
                        name: companyNameAr,
                        latinName: companyNameEn,
                        userId: id,
                        imageBytes: user.image,
                      ),
                      const SizedBox(height: 16),

                      // ==================================================
                      // FACILITY / COMPANY DATA CARD
                      // ==================================================
                      DetailSectionCard(
                        title: LocaleKeys.facilityData,
                        icon: Icons.business_rounded,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            UserTextFieldWidget(
                              initialValue: companyNameAr,
                              text: LocaleKeys.facilityNameKey,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              initialValue: companyNameEn,
                              text: LocaleKeys.facilityNameENKey,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              initialValue: phone,
                              text: LocaleKeys.phoneNumber,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              initialValue: email,
                              text: LocaleKeys.Email,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              initialValue: cr,
                              text: LocaleKeys.commercialRecordKey,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              initialValue: vatNo,
                              text: LocaleKeys.taxNumberKey,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              initialValue: id,
                              text: LocaleKeys.identity,
                              readOnly: true,
                              width: 260,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ==================================================
                      // DOCUMENTS & ATTACHMENTS CARD
                      // ==================================================
                      DetailSectionCard(
                        title: LocaleKeys.documents,
                        icon: Icons.folder_shared_outlined,
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 20,
                          children: [
                            ReadOnlyImageCard(
                              title: LocaleKeys.taxNumberKey,
                              image: user.companyDetails?.vatimage,
                            ),
                            ReadOnlyImageCard(
                              title: LocaleKeys.commercialRecordFileKey,
                              image: user.companyDetails?.crimage,
                            ),
                            ReadOnlyImageCard(
                              title: LocaleKeys.ownerIdKey,
                              image: user.companyDetails?.identityimage,
                            ),
                            if (user.image != null)
                              ReadOnlyImageCard(
                                title: LocaleKeys.facilityIdentityKey,
                                image: user.image,
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}

class CompanyHeaderCard extends StatelessWidget {
  final String name;
  final String latinName;
  final String userId;
  final dynamic imageBytes;

  const CompanyHeaderCard({
    super.key,
    required this.name,
    required this.latinName,
    required this.userId,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: Row(
        children: [
          imageBytes != null
              ? CircleAvatar(
                  radius: 26,
                  backgroundImage: MemoryImage(imageBytes),
                )
              : const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.greyColor200,
                  child: Icon(
                    Icons.business,
                    size: 28,
                    color: AppColors.orangeColor,
                  ),
                ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextInAppWidget(
                        text: name.isNotEmpty ? name : '---',
                        textSize: 16,
                        fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                        textColor: AppColors.blackColor,
                        maxLines: 1,
                        isEllipsisTextOverflow: true,
                      ),
                    ),
                    if (userId.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orangeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextInAppWidget(
                          text: '#$userId',
                          textSize: 11,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.orangeColor,
                        ),
                      ),
                    ],
                  ],
                ),
                if (latinName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  TextInAppWidget(
                    text: latinName,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.darkGreyColor,
                    maxLines: 1,
                    isEllipsisTextOverflow: true,
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
