import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/notifications/data/datasource/get_user_new_notification_datasource/get_user_new_notification_datasource.dart';
import '../../../../../../features/notifications/data/datasource/get_user_notification_datasource/get_user_notification_datasource.dart';
import '../../../../../../features/notifications/data/datasource/make_notification_viewed_datasource/make_notification_viewed_datasource.dart';
import '../../../../../../features/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import '../../../../../../features/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import '../../../../../../features/notifications/presentation/bloc/notification_cubit/notification_state.dart';


class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  GetUserNewNotificationResponse? newNotification;
  List<GetUserNewNotificationResponse> notifications = [];

  Future<void> getUserNewNotification({
    required int userId,
    required int userType,
  }) async {
    emit(NotificationLoading());

    try {
      newNotification = await getUserNewNotificationFunction(
        request: GetUserNewNotificationRequest(
          userId: userId,
          userType: userType,
        ),
      );

      emit(NotificationNewSuccess(newNotification!));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> getUserNotification({
    required int userId,
    required int userType,
  }) async {
    emit(NotificationLoading());

    try {
      notifications = await getUserNotificationFunction(
        request: GetUserNewNotificationRequest(
          userId: userId,
          userType: userType,
        ),
      );

      emit(NotificationSuccess(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
  Future<void> makeNotificationViewed({
    required int userId,
    required int userType,
  }) async {
    try {
      await makeNotificationViewedFunction(
        request: GetUserNewNotificationRequest(
          userId: userId,
          userType: userType,
        ),
      );
      await getUserNotification(
        userId: userId,
        userType: userType,
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}