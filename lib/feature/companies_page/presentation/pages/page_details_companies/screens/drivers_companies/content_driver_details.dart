import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_driver_details_cubit/get_driver_details_cubit.dart';
import 'package:web_admin_san/feature/companies_page/view_model/get_driver_details_cubit/get_driver_details_state.dart';
import 'package:web_admin_san/core/widgets/detail_section_card.dart';
import 'package:web_admin_san/feature/providers_page/presentation/widgets/read_only_image_card.dart';

class ContentDriverDetails extends StatefulWidget {
  final int driverId;

  const ContentDriverDetails({
    super.key,
    required this.driverId,
  });

  @override
  State<ContentDriverDetails> createState() => _ContentDriverDetailsState();
}

class _ContentDriverDetailsState extends State<ContentDriverDetails> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final activeController = TextEditingController();
  final typeController = TextEditingController();
  final carController = TextEditingController();
  final plateController = TextEditingController();

  void _setDriverData(dynamic driver) {
    idController.text = driver.id?.toString() ?? '';
    nameController.text = driver.name ?? '';
    phoneController.text = driver.phone ?? '';
    emailController.text = driver.email ?? '';
    companyController.text = driver.companyId?.toString() ?? '';
    activeController.text =
        driver.isActive == true ? LocaleKeys.active : LocaleKeys.inactive;
    typeController.text = driver.type?.toString() ?? '';

    final firstCar = (driver.cars != null && driver.cars.isNotEmpty)
        ? driver.cars.first
        : null;
    carController.text =
        "${firstCar?.brand?.brandName ?? ""} ${firstCar?.model?.modelName ?? ""}"
            .trim();
    plateController.text = firstCar?.plateNo ?? '';
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    companyController.dispose();
    activeController.dispose();
    typeController.dispose();
    carController.dispose();
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetDriverDetailsCubit, GetDriverDetailsState>(
      listener: (context, state) {
        if (state is GetDriverDetailsSuccess) {
          _setDriverData(state.model);
        }
      },
      builder: (context, state) {
        if (state is GetDriverDetailsLoading) {
          return const SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is GetDriverDetailsFailure) {
          return SizedBox(
            height: 400,
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.redColor),
              ),
            ),
          );
        }

        if (state is GetDriverDetailsSuccess) {
          final driver = state.model;
          if (nameController.text.isEmpty && driver.name != null) {
            _setDriverData(driver);
          }

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: RefreshIndicator(
              color: AppColors.orangeColor,
              onRefresh: () async {
                await context.read<GetDriverDetailsCubit>().getDriverDetails(
                      driverId: widget.driverId,
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ==================================================
                      // USER HEADER CARD
                      // ==================================================
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
                            driver.image != null
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundImage: MemoryImage(driver.image!),
                                  )
                                : const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: AppColors.greyColor200,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                            const SizedBox(width: 12),
                            TextInAppWidget(
                              text: driver.name ?? "",
                              textSize: 16,
                              fontWeightIndex:
                                  FontSelectionData.semiBoldFontFamily,
                              textColor: AppColors.blackColor,
                            ),
                          ],
                        ),
                      ),

                      // ==================================================
                      // PERSONAL DATA CARD
                      // ==================================================
                      DetailSectionCard(
                        title: LocaleKeys.personalData,
                        icon: Icons.person_outline_rounded,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            UserTextFieldWidget(
                              controller: idController,
                              text: LocaleKeys.identity,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: nameController,
                              text: LocaleKeys.userName,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: phoneController,
                              text: LocaleKeys.phoneNumber,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: emailController,
                              text: LocaleKeys.Email,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: companyController,
                              text: LocaleKeys.companyId,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: activeController,
                              text: LocaleKeys.accountStatus,
                              readOnly: true,
                              width: 260,
                            ),
                          ],
                        ),
                      ),

                      // ==================================================
                      // VEHICLE DATA CARD
                      // ==================================================
                      DetailSectionCard(
                        title: LocaleKeys.cars,
                        icon: Icons.directions_car_outlined,
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            UserTextFieldWidget(
                              controller: typeController,
                              text: LocaleKeys.type,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: carController,
                              text: LocaleKeys.carModel,
                              readOnly: true,
                              width: 260,
                            ),
                            UserTextFieldWidget(
                              controller: plateController,
                              text: LocaleKeys.plateNumber,
                              readOnly: true,
                              width: 260,
                            ),
                          ],
                        ),
                      ),

                      // ==================================================
                      // DOCUMENTS CARD
                      // ==================================================
                      DetailSectionCard(
                        title: LocaleKeys.documents,
                        icon: Icons.folder_shared_outlined,
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 20,
                          children: [
                            ReadOnlyImageCard(
                              title: LocaleKeys.driverImage,
                              image: driver.image,
                            ),
                            ReadOnlyImageCard(
                              title: LocaleKeys.licenseImage,
                              image: driver.licenseImage,
                            ),
                            ReadOnlyImageCard(
                              title: LocaleKeys.identityImage,
                              image: driver.identityImage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
