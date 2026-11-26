import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/feature/notifications/data/datasource/get_user_new_notification_datasource/get_user_new_notification_datasource.dart';
import 'package:web_admin_san/feature/notifications/data/datasource/get_user_notification_datasource/get_user_notification_datasource.dart';
import 'package:web_admin_san/feature/notifications/data/datasource/make_notification_viewed_datasource/make_notification_viewed_datasource.dart';
import 'package:web_admin_san/feature/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import 'package:web_admin_san/feature/notifications/data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  NotificationModel? newNotification;

  List<NotificationModel> notifications = [];

  int get unreadCount => notifications.where((e) => e.isViewed == false).length;

  int _pageNumber = 1;
  final int _pageSize = 10;

  bool hasMore = true;
  bool isLoadingMore = false;

  int totalCount = 0;
  int pageCount = 0;

  bool _isSameNotification(NotificationModel a, NotificationModel b) {
    // 1. Direct ID match if both have valid non-zero IDs
    if (a.id != null && b.id != null && a.id != 0 && b.id != 0) {
      return a.id == b.id;
    }

    // 2. If one is viewed and the other is unread, they are not the same notification
    if (a.isViewed != b.isViewed) {
      return false;
    }

    // 3. Normalize titles and descriptions
    final aTitle = (a.title ?? a.latinTitle ?? '').trim().toLowerCase();
    final bTitle = (b.title ?? b.latinTitle ?? '').trim().toLowerCase();
    final aDesc = (a.description ?? a.latinDesc ?? '').trim().toLowerCase();
    final bDesc = (b.description ?? b.latinDesc ?? '').trim().toLowerCase();

    // If descriptions are distinct, they are different messages
    if (aDesc.isNotEmpty && bDesc.isNotEmpty && aDesc != bDesc) {
      return false;
    }

    final bool titleMatch =
        aTitle.isNotEmpty && bTitle.isNotEmpty && aTitle == bTitle;
    final bool descMatch =
        aDesc.isNotEmpty && bDesc.isNotEmpty && aDesc == bDesc;

    if (titleMatch && descMatch) {
      // 4. Sender check if available on both
      if (a.fromUserId != null &&
          b.fromUserId != null &&
          a.fromUserId != 0 &&
          b.fromUserId != 0) {
        if (a.fromUserId != b.fromUserId) return false;
      }

      // 5. Proximity check on dates (within 10 seconds only)
      if (a.date != null && b.date != null) {
        final diffSeconds =
            a.date!.toUtc().difference(b.date!.toUtc()).inSeconds.abs();
        return diffSeconds <= 10;
      }
      return true;
    }

    return false;
  }

  void addNotification(NotificationModel item) {
    if (isClosed) return;

    final unreadItem = item.copyWith(isViewed: false);

    // If an exact duplicate unread already exists (within 10 seconds), update it in place
    final existingIndex =
        notifications.indexWhere((n) => _isSameNotification(n, unreadItem));
    if (existingIndex >= 0) {
      notifications[existingIndex] = unreadItem;
    } else {
      notifications.insert(0, unreadItem);
      totalCount = notifications.length;
    }

    safeEmit(NotificationSuccess(List<NotificationModel>.from(notifications)));
  }

  void safeEmit(NotificationState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  void markAllAsViewedLocally() {
    if (notifications.isEmpty) return;
    bool hasChanges = false;
    notifications = notifications.map((item) {
      if (item.isViewed != true) {
        hasChanges = true;
        return item.copyWith(isViewed: true);
      }
      return item;
    }).toList();

    if (hasChanges && !isClosed) {
      safeEmit(
          NotificationSuccess(List<NotificationModel>.from(notifications)));
    }
  }

  void markAsViewed(NotificationModel item) {
    if (isClosed) return;
    final index = notifications.indexWhere((n) => _isSameNotification(n, item));

    if (index != -1 && notifications[index].isViewed != true) {
      notifications[index] = notifications[index].copyWith(isViewed: true);
      safeEmit(
          NotificationSuccess(List<NotificationModel>.from(notifications)));
    }
  }

  void markNotificationsFromSenderAsViewed({
    required int fromUserId,
    required int fromUserType,
    String? fromUserName,
  }) {
    if (notifications.isEmpty || isClosed) return;
    bool hasChanges = false;
    final normalizedSender = (fromUserName ?? '').trim().toLowerCase();

    notifications = notifications.map((item) {
      final matchesId = item.fromUserId != null &&
          item.fromUserId != 0 &&
          item.fromUserId == fromUserId &&
          (item.fromUserType == null ||
              item.fromUserType == 0 ||
              item.fromUserType == fromUserType);

      final itemTitle =
          (item.title ?? item.latinTitle ?? '').trim().toLowerCase();
      final matchesName = normalizedSender.isNotEmpty &&
          itemTitle.isNotEmpty &&
          (itemTitle == normalizedSender ||
              itemTitle.contains(normalizedSender));

      if ((matchesId || matchesName) && item.isViewed != true) {
        hasChanges = true;
        return item.copyWith(isViewed: true);
      }
      return item;
    }).toList();

    if (hasChanges && !isClosed) {
      safeEmit(
          NotificationSuccess(List<NotificationModel>.from(notifications)));
    }
  }

  Future<void> getUserNotification() async {
    if (isClosed) return;

    if (notifications.isEmpty) {
      safeEmit(NotificationLoading());
    }

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

      final fetched = List<NotificationModel>.from(userResponse.data);
      final localNotifications = List<NotificationModel>.from(notifications);

      // Start with server fetched items as source of truth
      final List<NotificationModel> merged =
          List<NotificationModel>.from(fetched);

      // Preserve local viewed status if marked viewed before backend sync, and preserve unread if marked unread locally
      for (int i = 0; i < merged.length; i++) {
        final item = merged[i];
        final localMatch = notifications.firstWhere(
          (n) => _isSameNotification(n, item),
          orElse: () => item,
        );

        if (localMatch.isViewed == false && item.isViewed == true) {
          merged[i] = item.copyWith(isViewed: false);
        } else if (localMatch.isViewed == true && item.isViewed != true) {
          merged[i] = item.copyWith(isViewed: true);
        }
      }

      // Only preserve local notifications not yet returned by backend
      for (final local in localNotifications) {
        final alreadyFetched =
            merged.any((item) => _isSameNotification(item, local));
        if (!alreadyFetched) {
          merged.add(local);
        }
      }

      // Deduplicate to guarantee zero duplicate tiles in dropdown
      final List<NotificationModel> uniqueNotifications = [];
      for (final item in merged) {
        if (!uniqueNotifications
            .any((existing) => _isSameNotification(existing, item))) {
          uniqueNotifications.add(item);
        }
      }

      uniqueNotifications.sort(
        (a, b) =>
            (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()),
      );

      notifications = uniqueNotifications;

      totalCount = userResponse.totalCount > notifications.length
          ? userResponse.totalCount
          : notifications.length;
      pageCount = userResponse.pageCount;
      hasMore = _pageNumber < pageCount;

      safeEmit(NotificationSuccess(notifications));
    } catch (e) {
      if (notifications.isEmpty) {
        safeEmit(NotificationError(e.toString()));
      }
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

    markAllAsViewedLocally();

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
    } catch (_) {
      // Gracefully ignore network errors on mark-viewed; local viewed state is retained
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

      for (final item in userResponse.data) {
        if (!notifications
            .any((existing) => _isSameNotification(existing, item))) {
          notifications.add(item);
        }
      }

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
