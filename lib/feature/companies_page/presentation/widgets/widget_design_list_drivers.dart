import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/widgets/title_with_sub_title.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/widgets/custom_container.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';

class WidgetDesignListDrivers extends StatelessWidget {
  const WidgetDesignListDrivers({
    super.key,
    this.id,
    this.spacing,
    this.name,
    this.onTabDetails,
    this.nameButton,
    this.imageUser,
    this.email,
    this.phone,
    this.plateNo,
    this.nameBrandModel,
    this.imageBrand,
    this.isActive = true,
  });

  final String? id, name, nameButton, phone, email, nameBrandModel, plateNo;
  final double? spacing;
  final void Function()? onTabDetails;
  final Uint8List? imageUser, imageBrand;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      containerWidth: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      typeWidget: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          if (isDesktop) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 90,
                  child: DriverIdentitySection(id: id),
                ),
                Expanded(
                  flex: 3,
                  child: DriverProfileSection(
                    name: name,
                    imageUser: imageUser,
                    isActive: isActive,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: DriverVehicleSection(
                    nameBrandModel: nameBrandModel,
                    plateNo: plateNo,
                    imageBrand: imageBrand,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: DriverContactSection(
                    title: LocaleKeys.Email,
                    subTitle:
                        (email != null && email!.isNotEmpty) ? email! : '---',
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DriverContactSection(
                    title: LocaleKeys.phoneNumber,
                    subTitle:
                        (phone != null && phone!.isNotEmpty) ? phone! : '---',
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: DriverDetailsButton(
                    nameButton: nameButton,
                    onTap: onTabDetails,
                  ),
                ),
              ],
            );
          }

          // Responsive layout for tablets / mobile
          return Wrap(
            spacing: spacing ?? 20,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 90,
                child: DriverIdentitySection(id: id),
              ),
              SizedBox(
                width: 220,
                child: DriverProfileSection(
                  name: name,
                  imageUser: imageUser,
                  isActive: isActive,
                ),
              ),
              SizedBox(
                width: 200,
                child: DriverVehicleSection(
                  nameBrandModel: nameBrandModel,
                  plateNo: plateNo,
                  imageBrand: imageBrand,
                ),
              ),
              SizedBox(
                width: 180,
                child: DriverContactSection(
                  title: LocaleKeys.Email,
                  subTitle:
                      (email != null && email!.isNotEmpty) ? email! : '---',
                ),
              ),
              SizedBox(
                width: 150,
                child: DriverContactSection(
                  title: LocaleKeys.phoneNumber,
                  subTitle:
                      (phone != null && phone!.isNotEmpty) ? phone! : '---',
                ),
              ),
              SizedBox(
                width: 100,
                child: DriverDetailsButton(
                  nameButton: nameButton,
                  onTap: onTabDetails,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DriverIdentitySection extends StatelessWidget {
  final String? id;

  const DriverIdentitySection({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return TitleWithSubTitle(
      title: LocaleKeys.identity,
      subTitle: id ?? '#1',
      textSizeTitle: 12,
      titleColor: AppColors.greyColor,
      textSizeSubTitle: 14,
      subTitleColor: AppColors.darkColor,
    );
  }
}

class DriverProfileSection extends StatelessWidget {
  final String? name;
  final Uint8List? imageUser;
  final bool isActive;

  const DriverProfileSection({
    super.key,
    required this.name,
    required this.imageUser,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        imageUser != null
            ? CircleAvatar(
                radius: 20,
                backgroundImage: MemoryImage(imageUser!),
              )
            : const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.orangeColor,
                child: Icon(Icons.person, color: AppColors.whiteColor),
              ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInAppWidget(
                text: name ?? '###',
                textSize: 14,
                fontWeightIndex: FontSelectionData.mediumFontFamily,
                textColor: AppColors.blackColor,
                maxLines: 1,
                isEllipsisTextOverflow: true,
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.greenColor.withValues(alpha: 0.12)
                      : AppColors.redColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextInAppWidget(
                  text: isActive ? LocaleKeys.active : LocaleKeys.notActive,
                  textSize: 10,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor:
                      isActive ? AppColors.greenColor : AppColors.redColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DriverVehicleSection extends StatelessWidget {
  final String? nameBrandModel;
  final String? plateNo;
  final Uint8List? imageBrand;

  const DriverVehicleSection({
    super.key,
    required this.nameBrandModel,
    required this.plateNo,
    required this.imageBrand,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        imageBrand != null
            ? Image.memory(
                imageBrand!,
                width: 44,
                height: 36,
                fit: BoxFit.contain,
              )
            : Image.asset(
                AppImageKeys.car501,
                width: 44,
                height: 36,
                fit: BoxFit.contain,
              ),
        const SizedBox(width: 8),
        Flexible(
          child: TitleWithSubTitle(
            title: nameBrandModel ?? '--',
            subTitle: plateNo ?? '--',
            textSizeTitle: 12,
            titleColor: AppColors.darkColor,
            textSizeSubTitle: 12,
            subTitleColor: AppColors.darkColor,
          ),
        ),
      ],
    );
  }
}

class DriverContactSection extends StatelessWidget {
  final String title;
  final String subTitle;

  const DriverContactSection({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return TitleWithSubTitle(
      title: title,
      subTitle: subTitle,
      textSizeTitle: 12,
      titleColor: AppColors.greyColor,
      textSizeSubTitle: 13,
      subTitleColor: AppColors.darkColor,
    );
  }
}

class DriverDetailsButton extends StatelessWidget {
  final String? nameButton;
  final VoidCallback? onTap;

  const DriverDetailsButton({
    super.key,
    required this.nameButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            border: Border.all(
              color: AppColors.orangeColor,
            ),
          ),
          child: Center(
            child: TextInAppWidget(
              text: nameButton ?? LocaleKeys.details,
              textSize: 12,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.orangeColor,
            ),
          ),
        ),
      ),
    );
  }
}
