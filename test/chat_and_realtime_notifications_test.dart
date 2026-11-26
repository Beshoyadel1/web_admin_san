import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/feature/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/feature/technical_support_page/data/datasource/admin_chat_repository.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/admin_chat_model.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_state.dart';

class MockAdminChatRepository extends AdminChatRepository {
  List<GetAllMessagesModel> unassignedResult = [];
  List<GetAllMessagesModel> mineResult = [];
  List<GetAllMessagesModel> closedResult = [];
  List<GetAllMessagesModel> allUserChatsResult = [];

  @override
  Future<List<GetAllMessagesModel>> getSupportTickets({
    required int adminId,
    required String status,
    String lang = 'ar',
  }) async {
    if (status == 'unassigned') return unassignedResult;
    if (status == 'mine') return mineResult;
    if (status == 'closed') return closedResult;
    return [];
  }

  @override
  Future<List<GetAllMessagesModel>> getAllMessages({
    required int userId,
    required int userType,
  }) async {
    return allUserChatsResult;
  }

  @override
  Future<List<WorkTeamMemberModel>> getWorkTeam({
    required int userId,
    required int userType,
  }) async {
    return [];
  }

  @override
  Future<bool> openCloseChat({
    required int fromUser,
    required int fromUserType,
    required int toUser,
    required int toUserType,
    required bool isClose,
    String lang = 'ar',
  }) async {
    if (isClose) {
      final item = GetAllMessagesModel(
        fromUser: fromUser,
        fromUserType: fromUserType,
        touser: fromUser,
        tousertype: fromUserType,
        isClosed: true,
        isAssigned: false,
      );
      mineResult.removeWhere((t) => (t.fromUser ?? t.touser) == fromUser);
      unassignedResult.removeWhere((t) => (t.fromUser ?? t.touser) == fromUser);
      closedResult.removeWhere((t) => (t.fromUser ?? t.touser) == fromUser);
      closedResult.add(item);
      for (final c in allUserChatsResult) {
        if ((c.fromUser ?? c.touser) == fromUser) {
          c.isClosed = true;
          c.isAssigned = false;
        }
      }
    } else {
      final item = GetAllMessagesModel(
        fromUser: fromUser,
        fromUserType: fromUserType,
        touser: fromUser,
        tousertype: fromUserType,
        isClosed: false,
        isAssigned: true,
      );
      unassignedResult.removeWhere((t) => (t.fromUser ?? t.touser) == fromUser);
      closedResult.removeWhere((t) => (t.fromUser ?? t.touser) == fromUser);
      mineResult.removeWhere((t) => (t.fromUser ?? t.touser) == fromUser);
      mineResult.add(item);
      for (final c in allUserChatsResult) {
        if ((c.fromUser ?? c.touser) == fromUser) {
          c.isClosed = false;
          c.isAssigned = true;
        }
      }
    }
    return true;
  }

  @override
  Future<bool> makeChatViewed({
    required int fromUser,
    required int fromUserType,
    required int toUser,
    required int toUserType,
    int? orderId,
  }) async {
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const storageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(storageChannel, (call) async {
    if (call.method == 'read') {
      return '{"userid": 1, "type": 6, "username": "Admin"}';
    }
    return null;
  });

  const audioGlobalChannel = MethodChannel('xyz.luan/audioplayers.global');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(audioGlobalChannel, (call) async => null);

  const audioChannel = MethodChannel('xyz.luan/audioplayers');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(audioChannel, (call) async => null);

  const pathChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathChannel, (call) async => '.');

  group('NotificationCubit Real-time Tests', () {
    late NotificationCubit cubit;

    setUp(() {
      cubit = NotificationCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test(
        'addNotification increments unreadCount and supports consecutive messages',
        () {
      expect(cubit.unreadCount, 0);

      // First message from Company #10
      cubit.addNotification(NotificationModel(
        id: 1,
        title: 'شركة الفجر',
        description: 'السلام عليكم',
        fromUserId: 10,
        fromUserType: 4,
        isViewed: false,
        date: DateTime.now().subtract(const Duration(seconds: 20)),
      ));

      expect(cubit.unreadCount, 1);
      expect(cubit.notifications.length, 1);

      // Second message from same company with different content
      cubit.addNotification(NotificationModel(
        id: 2,
        title: 'شركة الفجر',
        description: 'هل يمكن المساعدة؟',
        fromUserId: 10,
        fromUserType: 4,
        isViewed: false,
        date: DateTime.now(),
      ));

      expect(cubit.unreadCount, 2);
      expect(cubit.notifications.length, 2);
    });

    test(
        'markNotificationsFromSenderAsViewed resets unread count for that sender',
        () {
      cubit.addNotification(NotificationModel(
        id: 1,
        title: 'شركة الفجر',
        description: 'السلام عليكم',
        fromUserId: 10,
        fromUserType: 4,
        isViewed: false,
      ));

      cubit.addNotification(NotificationModel(
        id: 2,
        title: 'عميل آخر',
        description: 'استفسار',
        fromUserId: 20,
        fromUserType: 1,
        isViewed: false,
      ));

      expect(cubit.unreadCount, 2);

      cubit.markNotificationsFromSenderAsViewed(
        fromUserId: 10,
        fromUserType: 4,
      );

      expect(cubit.unreadCount, 1);
      expect(cubit.notifications.firstWhere((n) => n.fromUserId == 10).isViewed,
          isTrue);
      expect(cubit.notifications.firstWhere((n) => n.fromUserId == 20).isViewed,
          isFalse);
    });
  });

  group('AdminChatCubit Ticket Lifecycle & Tab Persistence', () {
    late MockAdminChatRepository mockRepo;
    late AdminChatCubit chatCubit;
    late NotificationCubit notifCubit;

    setUp(() {
      mockRepo = MockAdminChatRepository();
      chatCubit = AdminChatCubit(chatRepository: mockRepo);
      notifCubit = NotificationCubit();

      if (getIt.isRegistered<AdminChatCubit>()) {
        getIt.unregister<AdminChatCubit>();
      }
      if (getIt.isRegistered<NotificationCubit>()) {
        getIt.unregister<NotificationCubit>();
      }
      getIt.registerSingleton<AdminChatCubit>(chatCubit);
      getIt.registerSingleton<NotificationCubit>(notifCubit);
    });

    tearDown(() {
      chatCubit.close();
      notifCubit.close();
      getIt.reset();
    });

    test(
        'Accepting ticket keeps it in myTickets and purges from unassignedTickets',
        () async {
      final initialTicket = GetAllMessagesModel(
        fromUser: 10,
        fromUserType: 4,
        touser: 10,
        tousertype: 4,
        userName: 'شركة الفجر',
        isAssigned: false,
        isClosed: false,
      );

      mockRepo.unassignedResult = [initialTicket];
      mockRepo.allUserChatsResult = [initialTicket];

      await chatCubit.fetchSupportConversations();

      expect(chatCubit.state.unassignedTickets.length, 1);
      expect(chatCubit.state.myTickets.isEmpty, isTrue);

      // Accept ticket
      await chatCubit.acceptConversation(initialTicket);

      expect(chatCubit.state.conversationTab, ConversationTab.mine);
      expect(chatCubit.state.myTickets.length, 1);
      expect(chatCubit.state.myTickets.first.fromUser, 10);
      expect(chatCubit.state.myTickets.first.isAssigned, isTrue);
      expect(chatCubit.state.unassignedTickets.isEmpty, isTrue);
    });

    test(
        'Incoming message for accepted chat stays in myTickets and does not revert to unassigned',
        () async {
      final initialTicket = GetAllMessagesModel(
        fromUser: 10,
        fromUserType: 4,
        touser: 10,
        tousertype: 4,
        userName: 'شركة الفجر',
        isAssigned: false,
        isClosed: false,
      );

      mockRepo.unassignedResult = [initialTicket];
      mockRepo.allUserChatsResult = [initialTicket];
      await chatCubit.fetchSupportConversations();

      // Accept ticket
      await chatCubit.acceptConversation(initialTicket);
      expect(chatCubit.state.myTickets.length, 1);

      // Simulate navigating to another page and clearing selected chat
      chatCubit.clearSelectedChat();

      // Company sends a new message
      final newMsg = ChatMessageModel(
        id: 99,
        fromUser: 10,
        fromUserType: 4,
        toUser: 1, // Admin
        toUserType: UserType.adminUser,
        message: 'رسالة جديدة أثناء وجود الأدمن في صفحة أخرى',
        date: DateTime.now(),
        fromUserName: 'شركة الفجر',
      );

      chatCubit.onIncomingMessage(newMsg);

      // Verify chat remains in myTickets and NOT in unassigned
      expect(chatCubit.state.myTickets.length, 1);
      expect(chatCubit.state.myTickets.first.fromUser, 10);
      expect(chatCubit.state.myTickets.first.isAssigned, isTrue);
      expect(chatCubit.state.unassignedTickets.isEmpty, isTrue);

      // Verify notification bell updated
      expect(notifCubit.unreadCount, 1);
      expect(notifCubit.notifications.first.description,
          'رسالة جديدة أثناء وجود الأدمن في صفحة أخرى');

      // Now simulate returning to support page (init called)
      await chatCubit.fetchSupportConversations();

      // Must STILL be in myTickets and NOT in unassigned!
      expect(chatCubit.state.myTickets.length, 1);
      expect(chatCubit.state.myTickets.first.fromUser, 10);
      expect(chatCubit.state.myTickets.first.isAssigned, isTrue);
      expect(chatCubit.state.unassignedTickets.isEmpty, isTrue);
    });

    test(
        'Closed ticket reopens to unassigned on message 1, stays in unassigned on message 2, and moves to mine only when accepted',
        () async {
      final activeTicket = GetAllMessagesModel(
        fromUser: 50,
        fromUserType: 4,
        touser: 50,
        tousertype: 4,
        userName: 'شركة النور',
        isAssigned: true,
        isClosed: false,
      );

      mockRepo.mineResult = [activeTicket];
      mockRepo.allUserChatsResult = [activeTicket];
      await chatCubit.fetchSupportConversations();

      expect(chatCubit.state.myTickets.length, 1);

      // Close the conversation
      await chatCubit.closeConversation(activeTicket);
      expect(chatCubit.state.closedTickets.length, 1);
      expect(chatCubit.state.myTickets.isEmpty, isTrue);
      expect(chatCubit.state.unassignedTickets.isEmpty, isTrue);

      chatCubit.clearSelectedChat();

      // Company sends message #1
      final msg1 = ChatMessageModel(
        id: 101,
        fromUser: 50,
        fromUserType: 4,
        toUser: 1,
        toUserType: UserType.adminUser,
        message: 'مرحبا بعد الإغلاق 1',
        date: DateTime.now().subtract(const Duration(seconds: 30)),
        fromUserName: 'شركة النور',
      );
      chatCubit.onIncomingMessage(msg1);

      // Must be reopened into unassigned (جديدة), NOT mine!
      expect(chatCubit.state.unassignedTickets.length, 1);
      expect(chatCubit.state.unassignedTickets.first.fromUser, 50);
      expect(chatCubit.state.unassignedTickets.first.unViewedMessagesCount, 1);
      expect(chatCubit.state.myTickets.isEmpty, isTrue);

      // Company sends message #2 before admin accepts
      final msg2 = ChatMessageModel(
        id: 102,
        fromUser: 50,
        fromUserType: 4,
        toUser: 1,
        toUserType: UserType.adminUser,
        message: 'مرحبا بعد الإغلاق 2',
        date: DateTime.now(),
        fromUserName: 'شركة النور',
      );
      chatCubit.onIncomingMessage(msg2);

      // MUST STAY in unassigned with count 2, and NEVER jump to mine!
      expect(chatCubit.state.unassignedTickets.length, 1);
      expect(chatCubit.state.unassignedTickets.first.fromUser, 50);
      expect(chatCubit.state.unassignedTickets.first.unViewedMessagesCount, 2);
      expect(chatCubit.state.myTickets.isEmpty, isTrue);

      // Now admin accepts ticket
      await chatCubit
          .acceptConversation(chatCubit.state.unassignedTickets.first);

      // Now it moves to mine!
      expect(chatCubit.state.myTickets.length, 1);
      expect(chatCubit.state.myTickets.first.fromUser, 50);
      expect(chatCubit.state.unassignedTickets.isEmpty, isTrue);
    });
  });
}
