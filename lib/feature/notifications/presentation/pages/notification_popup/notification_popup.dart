import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_state.dart';
import 'package:web_admin_san/feature/notifications/presentation/pages/notification_list_widget/notification_list_widget.dart';

class NotificationPopup extends StatelessWidget {
  const NotificationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final cubit = context.read<NotificationCubit>();

        return Badge(
          isLabelVisible: cubit.unreadCount > 0,
          label: TextInAppWidget(
            text: cubit.unreadCount.toString(),
            textSize: 10,
            textColor: AppColors.whiteColor,
          ),
          child: PopupMenuButton(
            color: AppColors.scaffoldColor,
            offset: const Offset(0, 50),
            onOpened: () async {
              cubit.makeNotificationViewed();
              await cubit.getUserNotification();
              if (cubit.unreadCount > 0) {
                cubit.makeNotificationViewed();
              }
            },
            icon: const Icon(
              Icons.notifications,
              size: 34,
              color: AppColors.blackColor,
            ),
            itemBuilder: (_) => const [
              PopupMenuItem(
                enabled: false,
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 380,
                  height: 450,
                  child: NotificationListWidget(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
