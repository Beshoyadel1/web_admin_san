import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/calling_in_service_request/ui/screens/container_call_in_data_calling_design.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';

class ContainerContactWithCustomerOrderDetailsWidget extends StatelessWidget {
  final String? nameCustomer;
  final Uint8List? imageUser;

  const ContainerContactWithCustomerOrderDetailsWidget(
      {super.key, this.imageUser, this.nameCustomer});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {},
      isSelected: true,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.orangeColor.withOpacity(0.4)),
      typeWidget: Column(
        spacing: 10,
        children: [
          const TextInAppWidget(
            text: LocaleKeys.contactCustomer,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  imageUser != null
                      ? CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.transparent,
                          backgroundImage: MemoryImage(imageUser!),
                        )
                      : const CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.transparent,
                          backgroundImage: AssetImage(AppImageKeys.person22),
                        ),
                  TextInAppWidget(
                    text: nameCustomer ?? LocaleKeys.user,
                    textSize: 14,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  ),
                ],
              ),
              const Row(
                spacing: 15,
                children: [
                  ContainerCallInDataCallingDesign(
                    icon: Icons.call,
                    width: 40,
                  ),
                  ContainerCallInDataCallingDesign(
                    icon: Icons.message_outlined,
                    width: 40,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
