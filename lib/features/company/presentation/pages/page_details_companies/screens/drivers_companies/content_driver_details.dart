import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/assets.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_driver_details_cubit/get_driver_details_cubit.dart';
import 'package:web_admin_san/features/company/presentation/bloc/get_driver_details_cubit/get_driver_details_state.dart';
import 'package:web_admin_san/features/providers/presentation/custom_widget/read_only_image_card.dart';

class ContentDriverDetails extends StatelessWidget {
  const ContentDriverDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDriverDetailsCubit, GetDriverDetailsState>(
      builder: (context, state) {
        if (state is GetDriverDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GetDriverDetailsFailure) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is GetDriverDetailsSuccess) {
          final driver = state.model;

          final idController = TextEditingController(
            text: driver.id.toString(),
          );

          final nameController = TextEditingController(
            text: driver.name ?? '',
          );

          final phoneController = TextEditingController(
            text: driver.phone ?? '',
          );

          final emailController = TextEditingController(
            text: driver.email ?? '',
          );

          final companyController = TextEditingController(
            text: driver.companyId.toString(),
          );

          final activeController = TextEditingController(
            text: driver.isActive
                ? AppLanguageKeys.active
                : AppLanguageKeys.inactive,
          );

          final typeController = TextEditingController(
            text: driver.type.toString(),
          );

          final firstCar = driver.cars.isNotEmpty ? driver.cars.first : null;

          final carController = TextEditingController(
            text:
                "${firstCar?.brand?.brandName ?? ""} ${firstCar?.model?.modelName ?? ""}",
          );

          final plateController = TextEditingController(
            text: firstCar?.plateNo ?? '',
          );

          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsetsGeometry.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    driver.image != null
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage: MemoryImage(driver.image!),
                          )
                        : const CircleAvatar(radius: 25),
                    TextInAppWidget(
                      text: driver.name ?? "",
                      textSize: 15,
                      fontWeightIndex: FontSelectionData.mediumFontFamily,
                      textColor: AppColors.blackColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const TextInAppWidget(
                  text: AppLanguageKeys.personalData,
                  textSize: 15,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.orangeColor,
                ),
                const SizedBox(height: 15),
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
                      controller: nameController,
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
                      controller: companyController,
                      text: AppLanguageKeys.companyId,
                      readOnly: true,
                      width: 250,
                    ),
                    UserTextFieldWidget(
                      controller: activeController,
                      text: AppLanguageKeys.accountStatus,
                      readOnly: true,
                      width: 250,
                    ),
                    UserTextFieldWidget(
                      controller: typeController,
                      text: AppLanguageKeys.type,
                      readOnly: true,
                      width: 250,
                    ),
                    UserTextFieldWidget(
                      controller: carController,
                      text: AppLanguageKeys.carModel,
                      readOnly: true,
                      width: 250,
                    ),
                    UserTextFieldWidget(
                      controller: plateController,
                      text: AppLanguageKeys.plateNumber,
                      readOnly: true,
                      width: 250,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    ReadOnlyImageCard(
                      title: AppLanguageKeys.driverImage,
                      image: driver.image,
                    ),
                    ReadOnlyImageCard(
                      title: AppLanguageKeys.licenseImage,
                      image: driver.licenseImage,
                    ),
                    ReadOnlyImageCard(
                      title: AppLanguageKeys.identityImage,
                      image: driver.identityImage,
                    ),
                  ],
                ),
              ],
            ),
          ));
        }

        return const SizedBox();
      },
    );
  }
}
