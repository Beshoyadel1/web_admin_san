import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_state.dart';
import 'package:web_admin_san/feature/notifications/presentation/widgets/notification_item.dart';

class NotificationListWidget extends StatelessWidget {
  const NotificationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is NotificationError) {
          return Center(
            child: TextInAppWidget(
              text: state.message,
              textColor: AppColors.redColor,
              textSize: 12,
            ),
          );
        }

        final cubit = context.read<NotificationCubit>();

        if (cubit.notifications.isEmpty) {
          return const TextEmptyViewData();
        }

        final notifications = cubit.notifications;

        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: notifications.length + (cubit.hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            if (index == notifications.length) {
              return Center(
                child: InkWell(
                  onTap: cubit.loadMore,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: TextInAppWidget(
                      text: LocaleKeys.viewMore,
                      textSize: 14,
                      textColor: AppColors.greyColor,
                      fontWeightIndex: FontSelectionData.regularFontFamily,
                    ),
                  ),
                ),
              );
            }

            return NotificationItem(
              notification: notifications[index],
            );
          },
        );
      },
    );
  }
}
