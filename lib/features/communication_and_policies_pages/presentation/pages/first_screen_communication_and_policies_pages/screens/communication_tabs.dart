import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/pages_widgets/button_widget.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/presentation/cubit/all_pages_about_cubit/all_pages_about_cubit.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/presentation/cubit/all_pages_about_cubit/all_pages_about_state.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/presentation/custom_widget/tab_communication_and_policies_widget.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/presentation/custom_widget/first_name_textfield_personal_data_widget.dart';

class CommunicationTabs extends StatelessWidget {
  const CommunicationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: (){},
      typeWidget: BlocBuilder<AllPagesAboutCubit, AllPagesAboutState>(
        builder: (context, state) {
          if (state is AllPagesAboutLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AllPagesAboutError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is AllPagesAboutSuccess) {
            final cubit = context.read<AllPagesAboutCubit>();

            final isArabic = Directionality.of(context) == TextDirection.rtl;

            final page = state.pages[cubit.selectedIndex];

            final titleController =
                TextEditingController(text: page.titleText ?? "");
            final titleEnController =
                TextEditingController(text: page.titleTextEn ?? "");
            final contentController =
                TextEditingController(text: page.contentText ?? "");
            final contentEnController =
                TextEditingController(text: page.contentTextEn ?? "");

            return Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    state.pages.length,
                    (index) {
                      final item = state.pages[index];

                      return InkWell(
                        onTap: () {
                          cubit.selectPage(index);
                        },
                        child: TabCommunicationAndPoliciesWidget(
                          isSelected: cubit.selectedIndex == index,
                          text: item.getTitle(isArabic),
                        ),
                      );
                    },
                  ),
                ),
                FirstNameTextfieldPersonalDataWidget(
                  name: AppLanguageKeys.title,
                  isRegular: true,
                  textFormController: titleController,
                  textFormWidth: 500,
                  textFormHeight: 40,
                ),
                FirstNameTextfieldPersonalDataWidget(
                  name: AppLanguageKeys.titleEn,
                  isRegular: true,
                  textFormController: titleEnController,
                  textFormWidth: 500,
                  textFormHeight: 40,
                ),
                FirstNameTextfieldPersonalDataWidget(
                  name: AppLanguageKeys.contentText,
                  isRegular: true,
                  textFormController: contentController,
                  textFormWidth: 500,
                  maxLines: 3,
                ),
                FirstNameTextfieldPersonalDataWidget(
                  name: AppLanguageKeys.contentTextEn,
                  isRegular: true,
                  textFormController: contentEnController,
                  textFormWidth: 500,
                  maxLines: 3,
                ),
                BlocConsumer<AllPagesAboutCubit, AllPagesAboutState>(
                  listener: (context, state) {
                    if (state is UpdatePageAboutSuccess) {
                      AppSnackBar.showSuccess(AppLanguageKeys.success);
                    }

                    if (state is UpdatePageAboutError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ButtonWidget(
                      isFirstImageText: true,
                      //image: AppImageKeys.iconSend,
                      textColor: AppColors.whiteColor,
                      buttonColor: AppColors.orangeColor,
                      textSize: 12,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                      heightContainer: 30,
                      widthContainer: 150,
                      borderRadius: 30,
                      text: state is UpdatePageAboutLoading
                          ? AppLanguageKeys.loading
                          : AppLanguageKeys.edit,
                      onTap: state is UpdatePageAboutLoading
                          ? null
                          : () {
                              context
                                  .read<AllPagesAboutCubit>()
                                  .updatePageAbout(
                                    page: AboutPageModel(
                                      id: page.id,
                                      titleText: titleController.text,
                                      titleTextEn: titleEnController.text,
                                      contentText: contentController.text,
                                      contentTextEn: contentEnController.text,
                                    ),
                                  );
                            },
                    );
                  },
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
