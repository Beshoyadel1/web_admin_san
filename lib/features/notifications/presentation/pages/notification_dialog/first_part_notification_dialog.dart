import 'package:flutter/material.dart';
import '../../../../../core/signalr/signalr_service.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class FirstPartNotificationDialog extends StatelessWidget {
  final NotificationModel notification;

  const FirstPartNotificationDialog({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.greyColor,
          child:  Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        TextInAppWidget(
          text: notification.getTitle(context),
          textSize: 16,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),

        TextInAppWidget(
          text: notification.getDescription(context),
          textSize: 13,
          textAlign: TextAlign.center,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
      ],
    );
  }
}