import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/api/dio_function/api_constants.dart';
import 'package:web_admin_san/core/theming/auth_local_storage.dart';
import 'package:web_admin_san/features/notifications/data/datasource/get_user_new_notification_datasource/get_user_new_notification_datasource.dart';
import 'package:web_admin_san/features/notifications/data/datasource/get_user_notification_datasource/get_user_notification_datasource.dart';
import 'package:web_admin_san/features/notifications/data/datasource/make_notification_viewed_datasource/make_notification_viewed_datasource.dart';
import 'package:web_admin_san/features/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import 'package:web_admin_san/features/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import 'package:web_admin_san/features/notifications/presentation/bloc/notification_cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  NotificationModel? newNotification;

  List<NotificationModel> notifications = [];

  int get unreadCount =>
      notifications.where((e) => e.isViewed == false).length;

  int _pageNumber = 1;
  final int _pageSize = 10;

  bool hasMore = true;
  bool isLoadingMore = false;

  int totalCount = 0;
  int pageCount = 0;

  void safeEmit(NotificationState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> getUserNotification() async {
    if (isClosed) return;

    safeEmit(NotificationLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null || user.userid == null || user.userid == 0) {
        notifications = [];
        safeEmit(NotificationSuccess(notifications));
        return;
      }

      _pageNumber = 1;

      final userResponse = await getUserNotificationFunction(
        request: GetUserNewNotificationRequest(
          userId: user.userid!,
          userType: user.type ?? UserType.adminUser,
          pageNumber: _pageNumber,
          pageSize: _pageSize,
        ),
      );

      notifications = List<NotificationModel>.from(userResponse.data);

      notifications = {
        for (final item in notifications)
          if (item.id != null) item.id!: item,
      }.values.toList();

      notifications.sort(
        (a, b) =>
            (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()),
      );

      totalCount = userResponse.totalCount;
      pageCount = userResponse.pageCount;
      hasMore = _pageNumber < pageCount;

      safeEmit(NotificationSuccess(notifications));
    } catch (e) {
      safeEmit(NotificationError(e.toString()));
    }
  }

  Future<void> getUserNewNotification() async {
    if (isClosed) return;

    safeEmit(NotificationLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null || user.userid == null || user.userid == 0) {
        return;
      }

      newNotification = await getUserNewNotificationFunction(
        request: GetUserNewNotificationRequest(
          userId: user.userid!,
          userType: user.type ?? UserType.adminUser,
        ),
      );

      if (isClosed) return;

      if (newNotification != null) {
        safeEmit(NotificationNewSuccess(newNotification!));
      }
    } catch (e) {
      if (isClosed) return;
      safeEmit(NotificationError(e.toString()));
    }
  }

  Future<void> makeNotificationViewed() async {
    if (isClosed) return;

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null || user.userid == null || user.userid == 0) {
        return;
      }

      await makeNotificationViewedFunction(
        request: GetUserNewNotificationRequest(
          userId: user.userid!,
          userType: user.type ?? UserType.adminUser,
        ),
      );

      if (isClosed) return;

      await getUserNotification();
    } catch (e) {
      if (isClosed) return;
      safeEmit(NotificationError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null || user.userid == null || user.userid == 0) return;

      _pageNumber++;

      final userResponse = await getUserNotificationFunction(
        request: GetUserNewNotificationRequest(
          userId: user.userid!,
          userType: user.type ?? UserType.adminUser,
          pageNumber: _pageNumber,
          pageSize: _pageSize,
        ),
      );

      notifications.addAll(userResponse.data);

      notifications = {
        for (final item in notifications)
          if (item.id != null) item.id!: item,
      }.values.toList();

      notifications.sort(
        (a, b) =>
            (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()),
      );

      hasMore = _pageNumber < pageCount;

      safeEmit(NotificationSuccess(notifications));
    } catch (_) {
    } finally {
      isLoadingMore = false;
    }
  }
}