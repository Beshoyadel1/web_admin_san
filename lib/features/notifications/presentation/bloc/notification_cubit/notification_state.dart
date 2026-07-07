import '../../.../../../../../features/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<GetUserNewNotificationResponse> notifications;

  NotificationSuccess(this.notifications);
}

class NotificationNewSuccess extends NotificationState {
  final GetUserNewNotificationResponse notification;

  NotificationNewSuccess(this.notification);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}