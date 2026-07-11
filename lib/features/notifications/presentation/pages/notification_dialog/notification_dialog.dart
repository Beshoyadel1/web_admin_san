import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/signalr/signalr_service.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../features/notifications/presentation/pages/notification_dialog/first_part_notification_dialog.dart';
import '../../../../../features/notifications/presentation/pages/notification_dialog/last_two_button_notification_dialog.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onView,onClose;

  const NotificationDialog({
    super.key,
    required this.notification,
    this.onView,
    this.onClose
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          width: 420,
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FirstPartNotificationDialog(
                notification: notification,
              ),
              const SizedBox(height: 20),
              LastTwoButtonNotificationDialog(
                onTapView: onView,
                onTapClose:onClose
              ),
            ],
          ),
        ),
      ),
    );
  }
}