import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/di/sl.dart';
import 'package:web_admin_san/core/networking/api_link.dart';
import 'package:web_admin_san/core/networking/local_services.dart';
import 'package:web_admin_san/core/services/audio_service/audio_service.dart';
import 'package:web_admin_san/feature/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import 'package:web_admin_san/feature/notifications/data/model/receive_message_notification_model/receive_message_notification_model.dart';
import 'package:web_admin_san/feature/notifications/view_model/notification_cubit/notification_cubit.dart';
import 'package:web_admin_san/feature/notifications/presentation/widgets/html_notification_overlay.dart';
import 'package:web_admin_san/feature/notifications/presentation/services/navigation_service/navigation_service.dart';
import 'package:web_admin_san/feature/technical_support_page/data/datasource/admin_chat_repository.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/chat_events/chat_events.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/admin_chat_model.dart';
import 'admin_chat_state.dart';

class AdminChatCubit extends Cubit<AdminChatState> {
  final AdminChatRepository chatRepository;
  StreamSubscription<ReceiveMessageData>? _chatEventsSub;
  Timer? _activeChatPollTimer;
  Timer? _backgroundListPollTimer;
  final Set<String> _processedMessageKeys = {};

  int _cachedUserId = 0;
  int _cachedUserType = UserType.adminUser;

  AdminChatCubit({
    this.chatRepository = const AdminChatRepository(),
  }) : super(const AdminChatState()) {
    _initUser();
    _chatEventsSub = ChatEvents.instance.stream.listen((event) {
      _handleRealtimeChatEvent(event);
    });
  }

  void _initUser() {
    AuthLocalStorage.getUser().then((user) {
      if (user != null && user.userid != null) {
        _cachedUserId = user.userid!;
        _cachedUserType = user.type ?? UserType.adminUser;
      }
    });
  }

  int get currentUserId => _cachedUserId;
  int get currentUserType => _cachedUserType;

  int get totalUnreadCount =>
      state.calculateTotalUnread(currentUserId, currentUserType);

  void clearSelectedChat() {
    _stopActiveChatPolling();
    if (isClosed) return;
    ChatEvents.instance.activeChatUserId = null;
    ChatEvents.instance.activeChatUserType = null;
    emit(state.copyWith(clearSelectedChat: true));
  }

  (int, int) getPartner(GetAllMessagesModel m) => _getPartner(m);

  bool isSameConversation(GetAllMessagesModel a, GetAllMessagesModel b) =>
      _isSameConversation(a, b);

  bool _isSameConversation(GetAllMessagesModel a, GetAllMessagesModel b) {
    final aPartner = _getPartner(a);
    final bPartner = _getPartner(b);
    return aPartner.$1 > 0 &&
        aPartner.$1 == bPartner.$1 &&
        aPartner.$2 == bPartner.$2;
  }

  (int, int) _getPartner(GetAllMessagesModel m) {
    if (m.fromUserType != null &&
        m.fromUserType != UserType.adminUser &&
        m.fromUser != null &&
        m.fromUser! > 0) {
      return (m.fromUser!, m.fromUserType!);
    }
    if (m.tousertype != null &&
        m.tousertype != UserType.adminUser &&
        m.touser != null &&
        m.touser! > 0) {
      return (m.touser!, m.tousertype!);
    }
    return (
      m.fromUser ?? m.touser ?? 0,
      m.fromUserType ?? m.tousertype ?? 0,
    );
  }

  Future<void> init() async {
    final user = await AuthLocalStorage.getUser();
    if (user != null && user.userid != null) {
      _cachedUserId = user.userid!;
      _cachedUserType = user.type ?? UserType.adminUser;
    }

    _startBackgroundListPolling();

    await Future.wait([
      fetchSupportTickets(),
      getWorkTeam(),
    ]);
  }

  /// Alias for backward compatibility.
  Future<void> getAllMessages() => fetchSupportConversations();
  Future<void> fetchSupportTickets({bool silent = false}) =>
      fetchSupportConversations(silent: silent);

  /// Fetches all 3 conversation categories (unassigned, mine, closed) concurrently.
  Future<void> fetchSupportConversations({bool silent = false}) async {
    if (isClosed) return;
    if (!silent) {
      emit(state.copyWith(isLoadingMessages: true, clearErrorMessage: true));
    }

    try {
      if (_cachedUserId == 0) {
        final user = await AuthLocalStorage.getUser();
        if (user != null && user.userid != null) {
          _cachedUserId = user.userid!;
          _cachedUserType = user.type ?? UserType.adminUser;
        }
      }

      final results = await Future.wait([
        chatRepository
            .getSupportTickets(
              adminId: currentUserId,
              status: 'unassigned',
            )
            .catchError((_) => <GetAllMessagesModel>[]),
        chatRepository
            .getSupportTickets(
              adminId: currentUserId,
              status: 'mine',
            )
            .catchError((_) => <GetAllMessagesModel>[]),
        chatRepository
            .getSupportTickets(
              adminId: currentUserId,
              status: 'closed',
            )
            .catchError((_) => <GetAllMessagesModel>[]),
        chatRepository
            .getAllMessages(
              userId: currentUserId,
              userType: currentUserType,
            )
            .catchError((_) => <GetAllMessagesModel>[]),
      ]);

      if (isClosed) return;

      final unassigned = List<GetAllMessagesModel>.from(results[0]);
      final mine = List<GetAllMessagesModel>.from(results[1]);
      final closed = List<GetAllMessagesModel>.from(results[2]);
      final allUserChats = results[3];

      for (final t in unassigned) {
        t.isAssigned = false;
        t.isClosed = false;
      }
      for (final t in mine) {
        t.isAssigned = true;
        t.isClosed = false;
      }
      for (final t in closed) {
        t.isClosed = true;
      }

      (int, int) getPartner(GetAllMessagesModel m) {
        if (m.fromUserType != null &&
            m.fromUserType != UserType.adminUser &&
            m.fromUser != null &&
            m.fromUser! > 0) {
          return (m.fromUser!, m.fromUserType!);
        }
        if (m.tousertype != null &&
            m.tousertype != UserType.adminUser &&
            m.touser != null &&
            m.touser! > 0) {
          return (m.touser!, m.tousertype!);
        }
        return (
          m.fromUser ?? m.touser ?? 0,
          m.fromUserType ?? m.tousertype ?? 0,
        );
      }

      bool isMatch(GetAllMessagesModel a, GetAllMessagesModel b) {
        final aPartner = getPartner(a);
        final bPartner = getPartner(b);
        return aPartner.$1 > 0 &&
            aPartner.$1 == bPartner.$1 &&
            aPartner.$2 == bPartner.$2;
      }

      // 1. Process allUserChats: fallback classification only for chats not in getSupportTickets
      for (final c in allUserChats) {
        final inClosed = closed.any((t) => isMatch(t, c));
        if (inClosed || c.isClosed) {
          if (!inClosed) {
            c.isClosed = true;
            closed.add(c);
          }
          continue;
        }

        final inUnassigned = unassigned.any((t) => isMatch(t, c));
        if (inUnassigned) {
          continue;
        }

        final inMine = mine.any((t) => isMatch(t, c));
        if (inMine) {
          continue;
        }

        // Chat not present in any getSupportTickets category:
        if (c.isAssigned) {
          c.isAssigned = true;
          c.isClosed = false;
          mine.add(c);
        } else {
          c.isAssigned = false;
          c.isClosed = false;
          unassigned.add(c);
        }
      }

      // 2. Preserve local messages for tickets in mine
      for (final local in state.myTickets) {
        final isClosedNow =
            closed.any((t) => isMatch(t, local)) || local.isClosed;
        if (isClosedNow) continue;

        // If ticket is currently unassigned on the backend, it must NOT stay in mine!
        final isUnassignedNow = unassigned.any((t) => isMatch(t, local));
        if (isUnassignedNow) continue;

        final alreadyInMine = mine.indexWhere((t) => isMatch(t, local));
        if (alreadyInMine >= 0) {
          mine[alreadyInMine].isAssigned = true;
          mine[alreadyInMine].isClosed = false;
        }
      }

      // 3. Absolute consistency:
      // If a ticket is in unassigned, it can NEVER be in mine or closed!
      mine.removeWhere((m) =>
          unassigned.any((u) => isMatch(u, m)) ||
          closed.any((c) => isMatch(c, m)));

      // A ticket in closed can NEVER be in unassigned
      unassigned.removeWhere((u) => closed.any((c) => isMatch(c, u)));

      // 4. Preserve any unassigned tickets from state.unassignedTickets
      for (final local in state.unassignedTickets) {
        final isMineOrClosed = mine.any((t) => isMatch(t, local)) ||
            closed.any((t) => isMatch(t, local));
        if (isMineOrClosed) continue;

        if (!unassigned.any((t) => isMatch(t, local))) {
          unassigned.insert(0, local);
        }
      }

      List<GetAllMessagesModel> activeTabList;
      switch (state.ticketTab) {
        case TicketTab.unassigned:
          activeTabList = unassigned;
          break;
        case TicketTab.mine:
          activeTabList = mine;
          break;
        case TicketTab.closed:
          activeTabList = closed;
          break;
      }

      final filtered = _applySearch(activeTabList, state.searchQuery);

      GetAllMessagesModel? updatedSelectedChat;
      if (state.selectedChat != null) {
        final allCombined = [...unassigned, ...mine, ...closed];
        for (final c in allCombined) {
          if (_isSameConversation(c, state.selectedChat!)) {
            updatedSelectedChat = c.copyWith(
              messages: state.selectedChat!.messages,
              noOldMessages: state.selectedChat!.noOldMessages,
            );
            break;
          }
        }
        updatedSelectedChat ??= state.selectedChat;
      }

      emit(state.copyWith(
        isLoadingMessages: false,
        unassignedTickets: unassigned,
        myTickets: mine,
        closedTickets: closed,
        allMessages: activeTabList,
        filteredMessages: filtered,
        selectedChat: updatedSelectedChat,
      ));

      if (updatedSelectedChat != null &&
          (updatedSelectedChat.messages == null ||
              updatedSelectedChat.messages!.length <= 1)) {
        getOlderMessages(initialLoad: true);
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingMessages: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void changeConversationTab(ConversationTab tab) {
    if (isClosed) return;

    List<GetAllMessagesModel> tabList;
    switch (tab) {
      case ConversationTab.unassigned:
        tabList = state.unassignedConversations;
        break;
      case ConversationTab.mine:
        tabList = state.myConversations;
        break;
      case ConversationTab.closed:
        tabList = state.closedConversations;
        break;
    }

    final filtered = _applySearch(tabList, state.searchQuery);
    emit(state.copyWith(
      conversationTab: tab,
      allMessages: tabList,
      filteredMessages: filtered,
    ));
  }

  /// Alias for backward compatibility
  void changeTicketTab(ConversationTab tab) => changeConversationTab(tab);

  /// Claims / accepts an unassigned conversation on behalf of the current admin.
  Future<void> acceptConversation(GetAllMessagesModel chat) async {
    if (isClosed || state.isPerformingConversationAction) return;

    final targetUserId = chat.fromUser ?? chat.touser ?? 0;
    final targetUserType = chat.fromUserType ?? chat.tousertype ?? 0;
    if (targetUserId == 0 || targetUserType == 0) return;

    emit(state.copyWith(
      isPerformingConversationAction: true,
      clearConversationActionError: true,
      clearConversationActionSuccess: true,
    ));

    try {
      await chatRepository.openCloseChat(
        fromUser: targetUserId,
        fromUserType: targetUserType,
        toUser: currentUserId,
        toUserType: currentUserType,
        isClose: false,
      );

      if (isClosed) return;

      final updatedChat = chat.copyWith(
        isAssigned: true,
        isClosed: false,
        touser: targetUserId,
        tousertype: targetUserType,
      );

      bool isTarget(GetAllMessagesModel c) => _isSameConversation(c, chat);
      final updatedUnassigned =
          state.unassignedTickets.where((c) => !isTarget(c)).toList();
      final updatedClosed =
          state.closedTickets.where((c) => !isTarget(c)).toList();
      final updatedMine = [
        updatedChat,
        ...state.myTickets.where((c) => !isTarget(c)),
      ];

      final filtered = _applySearch(updatedMine, state.searchQuery);

      emit(state.copyWith(
        isPerformingConversationAction: false,
        conversationTab: ConversationTab.mine,
        ticketTab: TicketTab.mine,
        selectedChat: updatedChat,
        myTickets: updatedMine,
        unassignedTickets: updatedUnassigned,
        closedTickets: updatedClosed,
        allMessages: updatedMine,
        filteredMessages: filtered,
        conversationActionSuccess: LocaleKeys.chatAcceptedSuccessNotice.tr(),
      ));

      await fetchSupportConversations(silent: true);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isPerformingConversationAction: false,
        conversationActionError: e.toString().replaceFirst('Exception: ', ''),
      ));
      await fetchSupportConversations(silent: true);
    }
  }

  /// Alias for backward compatibility
  Future<void> acceptTicket(GetAllMessagesModel chat) =>
      acceptConversation(chat);

  /// Closes an active conversation.
  Future<void> closeConversation(GetAllMessagesModel chat) async {
    if (isClosed || state.isPerformingConversationAction) return;

    final targetUserId = chat.fromUser ?? chat.touser ?? 0;
    final targetUserType = chat.fromUserType ?? chat.tousertype ?? 0;
    if (targetUserId == 0 || targetUserType == 0) return;

    emit(state.copyWith(
      isPerformingConversationAction: true,
      clearConversationActionError: true,
      clearConversationActionSuccess: true,
    ));

    try {
      await chatRepository.openCloseChat(
        fromUser: targetUserId,
        fromUserType: targetUserType,
        toUser: currentUserId,
        toUserType: currentUserType,
        isClose: true,
      );

      if (isClosed) return;

      final closedChat = chat.copyWith(
        isClosed: true,
        isAssigned: false,
      );

      bool isTarget(GetAllMessagesModel c) => _isSameConversation(c, chat);
      final updatedMine = state.myTickets.where((c) => !isTarget(c)).toList();
      final updatedUnassigned =
          state.unassignedTickets.where((c) => !isTarget(c)).toList();
      final updatedClosed = List<GetAllMessagesModel>.from(state.closedTickets);
      final closedIdx = updatedClosed.indexWhere(isTarget);
      if (closedIdx >= 0) {
        updatedClosed[closedIdx] = closedChat;
      } else {
        updatedClosed.insert(0, closedChat);
      }

      List<GetAllMessagesModel> activeTabList;
      switch (state.ticketTab) {
        case TicketTab.unassigned:
          activeTabList = updatedUnassigned;
          break;
        case TicketTab.mine:
          activeTabList = updatedMine;
          break;
        case TicketTab.closed:
          activeTabList = updatedClosed;
          break;
      }

      ChatEvents.instance.activeChatUserId = null;
      ChatEvents.instance.activeChatUserType = null;

      emit(state.copyWith(
        isPerformingConversationAction: false,
        selectedChat: closedChat,
        myTickets: updatedMine,
        unassignedTickets: updatedUnassigned,
        closedTickets: updatedClosed,
        allMessages: activeTabList,
        filteredMessages: _applySearch(activeTabList, state.searchQuery),
        conversationActionSuccess: LocaleKeys.chatClosedSuccessNotice.tr(),
      ));

      await fetchSupportConversations(silent: true);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isPerformingConversationAction: false,
        conversationActionError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  /// Alias for backward compatibility
  Future<void> closeTicket(GetAllMessagesModel chat) => closeConversation(chat);

  Future<void> getWorkTeam() async {
    if (isClosed) return;
    emit(state.copyWith(isLoadingWorkTeam: true, clearErrorMessage: true));

    try {
      if (_cachedUserId == 0) {
        final user = await AuthLocalStorage.getUser();
        if (user != null && user.userid != null) {
          _cachedUserId = user.userid!;
          _cachedUserType = user.type ?? UserType.adminUser;
        }
      }

      final team = await chatRepository.getWorkTeam(
        userId: currentUserId,
        userType: currentUserType,
      );

      if (isClosed) return;

      emit(state.copyWith(
        isLoadingWorkTeam: false,
        workTeam: team,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingWorkTeam: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void selectChat(GetAllMessagesModel chat) {
    if (isClosed) return;

    final partner = _getPartner(chat);
    final targetId =
        partner.$1 > 0 ? partner.$1 : (chat.fromUser ?? chat.touser);
    final targetType =
        partner.$2 > 0 ? partner.$2 : (chat.fromUserType ?? chat.tousertype);

    ChatEvents.instance.activeChatUserId = targetId;
    ChatEvents.instance.activeChatUserType = targetType;

    final updatedMessages = chat.messages?.map((m) {
      return ChatMessageModel(
        id: m.id,
        fromUser: m.fromUser,
        toUser: m.toUser,
        fromUserType: m.fromUserType,
        toUserType: m.toUserType,
        message: m.message,
        date: m.date,
        viewed: true,
        isClosed: m.isClosed,
        orderId: m.orderId,
        harageId: m.harageId,
        fromUserName: m.fromUserName,
      );
    }).toList();

    final readChat = chat.copyWith(
      messages: updatedMessages,
      unViewedMessagesCount: 0,
    );

    // Update conversation lists so unread badges and tab badges clear immediately
    bool matchesTarget(GetAllMessagesModel c) {
      final p = _getPartner(c);
      return p.$1 == targetId && (targetType == null || p.$2 == targetType);
    }

    final updatedMyTickets =
        state.myTickets.map((c) => matchesTarget(c) ? readChat : c).toList();
    final updatedUnassigned = state.unassignedTickets
        .map((c) => matchesTarget(c) ? readChat : c)
        .toList();
    final updatedClosed = state.closedTickets
        .map((c) => matchesTarget(c) ? readChat : c)
        .toList();

    List<GetAllMessagesModel> activeTabList;
    switch (state.ticketTab) {
      case TicketTab.unassigned:
        activeTabList = updatedUnassigned;
        break;
      case TicketTab.mine:
        activeTabList = updatedMyTickets;
        break;
      case TicketTab.closed:
        activeTabList = updatedClosed;
        break;
    }

    final filtered = _applySearch(activeTabList, state.searchQuery);

    emit(state.copyWith(
      selectedChat: readChat,
      myTickets: updatedMyTickets,
      unassignedTickets: updatedUnassigned,
      closedTickets: updatedClosed,
      allMessages: activeTabList,
      filteredMessages: filtered,
    ));

    if (targetId != null && targetType != null) {
      _startActiveChatPolling();
      markChatViewed(targetId, targetType);
      if (chat.messages == null || chat.messages!.length <= 1) {
        getOlderMessages(initialLoad: true);
      }

      // Synchronize notification bell: clear unread notifications from this sender
      try {
        getIt<NotificationCubit>().markNotificationsFromSenderAsViewed(
          fromUserId: targetId,
          fromUserType: targetType,
          fromUserName: chat.userName,
        );
      } catch (_) {}
    }
  }

  void selectChatBySender(int senderId, int senderType) {
    if (isClosed) return;

    bool matches(GetAllMessagesModel c) {
      final p = _getPartner(c);
      return p.$1 == senderId && (senderType == 0 || p.$2 == senderType);
    }

    final inMine = state.myTickets.cast<GetAllMessagesModel?>().firstWhere(
          (c) => c != null && matches(c),
          orElse: () => null,
        );
    if (inMine != null) {
      changeConversationTab(ConversationTab.mine);
      selectChat(inMine);
      return;
    }

    final inUnassigned =
        state.unassignedTickets.cast<GetAllMessagesModel?>().firstWhere(
              (c) => c != null && matches(c),
              orElse: () => null,
            );
    if (inUnassigned != null) {
      changeConversationTab(ConversationTab.unassigned);
      selectChat(inUnassigned);
      return;
    }

    final inClosed =
        state.closedTickets.cast<GetAllMessagesModel?>().firstWhere(
              (c) => c != null && matches(c),
              orElse: () => null,
            );
    if (inClosed != null) {
      changeConversationTab(ConversationTab.closed);
      selectChat(inClosed);
      return;
    }

    final inAll = state.allMessages.cast<GetAllMessagesModel?>().firstWhere(
          (c) => c != null && matches(c),
          orElse: () => null,
        );
    if (inAll != null) {
      selectChat(inAll);
      return;
    }

    // If tickets haven't loaded yet, fetch and select
    fetchSupportConversations().then((_) {
      if (isClosed) return;
      selectChatBySender(senderId, senderType);
    });
  }

  void selectTab(int index) {
    if (isClosed) return;
    emit(state.copyWith(selectedTab: index));
  }

  void searchMessages(String query) {
    if (isClosed) return;
    final filtered = _applySearch(state.allMessages, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredMessages: filtered,
    ));
  }

  List<GetAllMessagesModel> _applySearch(
      List<GetAllMessagesModel> list, String query) {
    if (query.trim().isEmpty) return list;
    final lower = query.toLowerCase().trim();
    return list.where((item) {
      final name = item.userName?.toLowerCase() ?? '';
      final lastMsg = item.lastMessage?.message.toLowerCase() ?? '';
      return name.contains(lower) || lastMsg.contains(lower);
    }).toList();
  }

  bool _isSameOrOptimistic(
      ChatMessageModel existing, ChatMessageModel incoming) {
    if (existing.id != 0 && incoming.id != 0) {
      return existing.id == incoming.id;
    }

    if (existing.message.trim() == incoming.message.trim()) {
      if (existing.date != null &&
          incoming.date != null &&
          existing.date == incoming.date) {
        return true;
      }

      final isExistingOptimistic = existing.id == 0;
      final isIncomingOptimistic = incoming.id == 0;

      if (isExistingOptimistic || isIncomingOptimistic) {
        final sameSender = existing.fromUserType == incoming.fromUserType &&
            (existing.fromUser == incoming.fromUser ||
                existing.fromUser == 0 ||
                incoming.fromUser == 0);

        if (sameSender) {
          if (existing.date != null && incoming.date != null) {
            final diff = existing.date!.difference(incoming.date!).abs();
            return diff < const Duration(minutes: 5);
          }
          return true;
        }
      }
    }

    return false;
  }

  Future<void> sendMessage(String text, {int? orderId}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.selectedChat == null || isClosed) return;

    final targetChat = state.selectedChat!;
    if (targetChat.isClosed) return;

    final partner = _getPartner(targetChat);
    final toUser = partner.$1;
    final toUserType = partner.$2;
    if (toUser == 0 || toUserType == 0) return;

    // If ticket was unassigned, auto-assign to current admin
    if (!targetChat.isAssigned) {
      targetChat.isAssigned = true;
      chatRepository
          .openCloseChat(
            fromUser: toUser,
            fromUserType: toUserType,
            toUser: currentUserId,
            toUserType: currentUserType,
            isClose: false,
          )
          .catchError((_) => false);
    }

    final outgoingMessage = ChatMessageModel(
      id: 0,
      fromUser: currentUserId,
      fromUserType: currentUserType,
      toUser: toUser,
      toUserType: toUserType,
      message: trimmed,
      date: DateTime.now(),
      viewed: true,
      orderId: orderId,
    );

    // Optimistically update local message list
    final updatedMessages =
        List<ChatMessageModel>.from(targetChat.messages ?? [])
          ..add(outgoingMessage);

    final updatedChat = targetChat.copyWith(
      isAssigned: true,
      messages: updatedMessages,
      directLastMessage: outgoingMessage,
    );

    emit(state.copyWith(
      isSendingMessage: true,
      selectedChat: updatedChat,
    ));

    final sendModel = SendChatMessageModel(
      fromUser: currentUserId,
      fromUserType: currentUserType,
      toUser: toUser,
      toUserType: toUserType,
      orderId: orderId ?? 0,
      message: trimmed,
    );

    try {
      await chatRepository.sendChatMessage(message: sendModel);
      if (isClosed) return;
      emit(state.copyWith(isSendingMessage: false));
      await fetchSupportTickets(silent: true);
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isSendingMessage: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> getOlderMessages({bool initialLoad = false}) async {
    final chat = state.selectedChat;
    if (chat == null ||
        (chat.noOldMessages && !initialLoad) ||
        state.isLoadingOlder ||
        isClosed) {
      return;
    }

    final partner = _getPartner(chat);
    final targetId = partner.$1;
    final targetType = partner.$2;
    if (targetId == 0 || targetType == 0) return;

    final oldestDate =
        (initialLoad || chat.messages == null || chat.messages!.isEmpty)
            ? DateTime.now().add(const Duration(days: 1)).toIso8601String()
            : (chat.messages!.first.date?.toIso8601String() ??
                DateTime.now().add(const Duration(days: 1)).toIso8601String());

    emit(state.copyWith(isLoadingOlder: true, clearErrorMessage: true));

    try {
      List<ChatMessageModel> fetched;
      if (initialLoad) {
        fetched = await chatRepository.getChatMessages(
          fromUserId: currentUserId,
          fromUserType: currentUserType,
          toUserId: targetId,
          toUserType: targetType,
          isClosed: chat.isClosed ? true : null,
        );
      } else {
        fetched = await chatRepository.getOlderMessages(
          fromUser: currentUserId,
          fromUserType: currentUserType,
          toUser: targetId,
          toUserType: targetType,
          date: oldestDate,
          isClosed: chat.isClosed ? true : null,
        );
      }

      if (isClosed) return;

      final isStillSelected = state.selectedChat != null &&
          _isSameConversation(state.selectedChat!, chat);

      final currentMsgs = List<ChatMessageModel>.from(chat.messages ?? []);
      bool noMore = false;
      if (fetched.isEmpty || fetched.length < 10) {
        noMore = true;
      }

      if (initialLoad) {
        for (final msg in fetched) {
          final idx = currentMsgs.indexWhere(
            (m) => _isSameOrOptimistic(m, msg),
          );
          if (idx >= 0) {
            if (currentMsgs[idx].id == 0) {
              currentMsgs[idx] = msg;
            }
          } else {
            currentMsgs.add(msg);
          }
        }
        currentMsgs.sort((a, b) =>
            (a.date ?? DateTime.now()).compareTo(b.date ?? DateTime.now()));
      } else {
        for (final msg in fetched.reversed) {
          final idx = currentMsgs.indexWhere(
            (m) => _isSameOrOptimistic(m, msg),
          );
          if (idx >= 0) {
            if (currentMsgs[idx].id == 0) {
              currentMsgs[idx] = msg;
            }
          } else {
            currentMsgs.insert(0, msg);
          }
        }
      }

      final updatedChat = chat.copyWith(
        messages: currentMsgs,
        noOldMessages: noMore,
        unViewedMessagesCount: isStillSelected ? 0 : chat.unViewedMessagesCount,
      );

      bool matchesTarget(GetAllMessagesModel c) => _isSameConversation(c, chat);

      final updatedMyTickets = state.myTickets
          .map((c) => matchesTarget(c) ? updatedChat : c)
          .toList();
      final updatedUnassigned = state.unassignedTickets
          .map((c) => matchesTarget(c) ? updatedChat : c)
          .toList();
      final updatedClosed = state.closedTickets
          .map((c) => matchesTarget(c) ? updatedChat : c)
          .toList();

      List<GetAllMessagesModel> activeTabList;
      switch (state.ticketTab) {
        case TicketTab.unassigned:
          activeTabList = updatedUnassigned;
          break;
        case TicketTab.mine:
          activeTabList = updatedMyTickets;
          break;
        case TicketTab.closed:
          activeTabList = updatedClosed;
          break;
      }

      emit(state.copyWith(
        isLoadingOlder: false,
        selectedChat: isStillSelected ? updatedChat : state.selectedChat,
        myTickets: updatedMyTickets,
        unassignedTickets: updatedUnassigned,
        closedTickets: updatedClosed,
        allMessages: activeTabList,
        filteredMessages: _applySearch(activeTabList, state.searchQuery),
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        isLoadingOlder: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> markChatViewed(int toUser, int toUserType) async {
    try {
      await chatRepository.makeChatViewed(
        fromUser: currentUserId,
        fromUserType: currentUserType,
        toUser: toUser,
        toUserType: toUserType,
      );
    } catch (_) {}
  }

  void onIncomingMessage(ChatMessageModel message) {
    if (isClosed) return;

    final msgKey =
        '${message.id}_${message.fromUser}_${message.message}_${message.date?.millisecondsSinceEpoch}';
    if (_processedMessageKeys.contains(msgKey)) return;
    _processedMessageKeys.add(msgKey);
    if (_processedMessageKeys.length > 200) {
      _processedMessageKeys.remove(_processedMessageKeys.first);
    }

    final isFromMe = (currentUserId > 0 && message.fromUser == currentUserId) ||
        message.fromUserType == UserType.adminUser;
    final partnerId = isFromMe ? message.toUser : message.fromUser;
    final partnerType = isFromMe ? message.toUserType : message.fromUserType;

    final isForSelectedChat = state.selectedChat != null &&
        _getPartner(state.selectedChat!).$1 == partnerId &&
        _getPartner(state.selectedChat!).$2 == partnerType;

    final myTicketsList = List<GetAllMessagesModel>.from(state.myTickets);
    final unassignedTicketsList =
        List<GetAllMessagesModel>.from(state.unassignedTickets);
    final closedTicketsList =
        List<GetAllMessagesModel>.from(state.closedTickets);

    bool matchesMessage(GetAllMessagesModel c) {
      final p = _getPartner(c);
      return p.$1 == partnerId && p.$2 == partnerType;
    }

    final myIndex = myTicketsList.indexWhere(matchesMessage);
    final unassignedIndex = unassignedTicketsList.indexWhere(matchesMessage);
    final closedIndex = closedTicketsList.indexWhere(matchesMessage);

    GetAllMessagesModel? updatedSelected;

    if (isForSelectedChat) {
      final updatedMsgs =
          List<ChatMessageModel>.from(state.selectedChat!.messages ?? []);
      final existingIndex = updatedMsgs.indexWhere(
        (m) => _isSameOrOptimistic(m, message),
      );
      final effectiveMsg = message.copyWith(viewed: true);
      if (existingIndex >= 0) {
        if (updatedMsgs[existingIndex].id == 0) {
          updatedMsgs[existingIndex] = effectiveMsg;
        }
      } else {
        updatedMsgs.add(effectiveMsg);
      }
      updatedSelected = state.selectedChat!.copyWith(
        messages: updatedMsgs,
        directLastMessage: message,
        unViewedMessagesCount: 0,
        isClosed: false,
      );
      markChatViewed(message.fromUser, message.fromUserType);
      try {
        getIt<NotificationCubit>().markNotificationsFromSenderAsViewed(
          fromUserId: message.fromUser,
          fromUserType: message.fromUserType,
          fromUserName: message.fromUserName,
        );
      } catch (_) {}

      if (myIndex >= 0) {
        final existing = myTicketsList.removeAt(myIndex);
        myTicketsList.insert(
          0,
          existing.copyWith(
            messages: updatedMsgs,
            directLastMessage: message,
            unViewedMessagesCount: 0,
            isClosed: false,
            isAssigned: true,
          ),
        );
        unassignedTicketsList.removeWhere(matchesMessage);
        closedTicketsList.removeWhere(matchesMessage);
      } else if (closedIndex >= 0) {
        final existing = closedTicketsList.removeAt(closedIndex);
        unassignedTicketsList.insert(
          0,
          existing.copyWith(
            messages: updatedMsgs,
            directLastMessage: message,
            unViewedMessagesCount: 0,
            isClosed: false,
            isAssigned: false,
          ),
        );
        myTicketsList.removeWhere(matchesMessage);
      } else if (unassignedIndex >= 0) {
        final existing = unassignedTicketsList.removeAt(unassignedIndex);
        unassignedTicketsList.insert(
          0,
          existing.copyWith(
            messages: updatedMsgs,
            directLastMessage: message,
            unViewedMessagesCount: 0,
            isClosed: false,
            isAssigned: false,
          ),
        );
        myTicketsList.removeWhere(matchesMessage);
      }
    } else {
      // 1. Play chime audio & display notification if incoming from client / company
      if (!isFromMe) {
        AudioService.instance.playChime();
        try {
          final notifModel = NotificationModel(
            id: message.id != 0 ? message.id : null,
            title: message.fromUserName?.isNotEmpty == true
                ? message.fromUserName!
                : LocaleKeys.newTechnicalSupportMessage.tr(),
            description: message.message,
            latinTitle: message.fromUserName?.isNotEmpty == true
                ? message.fromUserName!
                : 'New Support Message',
            latinDesc: message.message,
            fromUserId: message.fromUser,
            fromUserType: message.fromUserType,
            toUserId: message.toUser,
            toUserType: message.toUserType,
            isViewed: false,
            date: message.date ?? DateTime.now(),
          );
          getIt<NotificationCubit>().addNotification(notifModel);
        } catch (_) {}

        try {
          final senderTitle = message.fromUserName?.isNotEmpty == true
              ? message.fromUserName!
              : LocaleKeys.newTechnicalSupportMessage.tr();
          HtmlNotificationOverlayService.show(
            title: senderTitle,
            body: message.message,
            userName: message.fromUserName,
            onView: () {
              const NotificationNavigationService().openChat();
              final pId = partnerId;
              final pType = partnerType;
              if (pId > 0) {
                selectChatBySender(pId, pType);
              }
            },
          );
        } catch (_) {}
      }

      // 2. Route ticket appropriately:
      // Priority 1: The chat is in my tickets ('محادثاتي') -> ALWAYS STAY in my tickets!
      if (myIndex >= 0) {
        final existing = myTicketsList.removeAt(myIndex);
        final currentMsgs = List<ChatMessageModel>.from(existing.messages ?? [])
          ..add(message);
        final updated = existing.copyWith(
          messages: currentMsgs,
          directLastMessage: message,
          unViewedMessagesCount: existing.unViewedMessagesCount + 1,
          isClosed: false,
          isAssigned: true,
        );
        myTicketsList.insert(0, updated);
        unassignedTicketsList.removeWhere(matchesMessage);
        closedTicketsList.removeWhere(matchesMessage);
      }
      // Priority 2: The chat was previously closed -> Reopen into unassigned ('جديدة')!
      else if (closedIndex >= 0) {
        final existing = closedTicketsList.removeAt(closedIndex);
        final currentMsgs = List<ChatMessageModel>.from(existing.messages ?? [])
          ..add(message);
        final updated = existing.copyWith(
          messages: currentMsgs,
          directLastMessage: message,
          unViewedMessagesCount: existing.unViewedMessagesCount + 1,
          isClosed: false,
          isAssigned: false,
        );
        unassignedTicketsList.insert(0, updated);
        myTicketsList.removeWhere(matchesMessage);
      }
      // Priority 3: The chat is in unassigned tickets ('جديدة') -> Stay in unassigned!
      else if (unassignedIndex >= 0) {
        final existing = unassignedTicketsList.removeAt(unassignedIndex);
        final currentMsgs = List<ChatMessageModel>.from(existing.messages ?? [])
          ..add(message);
        final updated = existing.copyWith(
          messages: currentMsgs,
          directLastMessage: message,
          unViewedMessagesCount: existing.unViewedMessagesCount + 1,
          isClosed: false,
          isAssigned: false,
        );
        unassignedTicketsList.insert(0, updated);
        myTicketsList.removeWhere(matchesMessage);
      }
      // Priority 4: Brand new conversation -> Put in unassigned ('جديدة')
      else {
        final newTicket = GetAllMessagesModel(
          touser: message.fromUser,
          tousertype: message.fromUserType,
          fromUser: message.fromUser,
          fromUserType: message.fromUserType,
          userName: message.fromUserName?.isNotEmpty == true
              ? message.fromUserName
              : '${LocaleKeys.user.tr()} #${message.fromUser}',
          messages: [message],
          directLastMessage: message,
          unViewedMessagesCount: 1,
          orderId: message.orderId,
          isAssigned: false,
          isClosed: false,
        );
        unassignedTicketsList.insert(0, newTicket);
      }
    }

    List<GetAllMessagesModel> activeTabList;
    switch (state.ticketTab) {
      case TicketTab.unassigned:
        activeTabList = unassignedTicketsList;
        break;
      case TicketTab.mine:
        activeTabList = myTicketsList;
        break;
      case TicketTab.closed:
        activeTabList = closedTicketsList;
        break;
    }

    final filtered = _applySearch(activeTabList, state.searchQuery);
    emit(state.copyWith(
      selectedChat: updatedSelected ?? state.selectedChat,
      myTickets: myTicketsList,
      unassignedTickets: unassignedTicketsList,
      closedTickets: closedTicketsList,
      allMessages: activeTabList,
      filteredMessages: filtered,
    ));

    // Refresh support tickets in background so counts & tabs stay in sync
    fetchSupportConversations(silent: true);
  }

  void _handleRealtimeChatEvent(ReceiveMessageData event) {
    final fromId = int.tryParse(event.fromUser ?? '') ?? 0;
    final fromType = int.tryParse(event.fromUserType ?? '') ?? 0;
    final toId = int.tryParse(event.toUser ?? '') ?? 0;
    final toType = int.tryParse(event.toUserType ?? '') ?? 0;

    final model = ChatMessageModel(
      id: int.tryParse(event.id ?? '') ?? 0,
      fromUser: fromId,
      toUser: toId,
      fromUserType: fromType,
      toUserType: toType,
      message: event.message ?? '',
      date:
          event.date != null ? (DateTime.tryParse(event.date!)?.toLocal() ?? DateTime.now()) : DateTime.now(),
      viewed: event.viewed == 'true' || event.viewed == '1',
      isClosed: event.isClosed == 'true' || event.isClosed == '1',
      orderId: int.tryParse(event.orderId ?? ''),
      harageId: int.tryParse(event.harageId ?? ''),
      fromUserName: event.fromUserName,
    );

    onIncomingMessage(model);
  }

  void onOpenCloseChatEvent(Map<String, dynamic> data) {
    if (isClosed) return;

    final isClosedRaw =
        data['isclosed'] ?? data['isClosed'] ?? data['ISCLOSED'];
    final bool isClosedVal =
        isClosedRaw == true || isClosedRaw?.toString().toLowerCase() == 'true';
    final int? toUser = int.tryParse(
        data['touser']?.toString() ?? data['toUser']?.toString() ?? '');

    fetchSupportConversations(silent: true);

    if (state.selectedChat != null) {
      final targetUserId =
          state.selectedChat!.fromUser ?? state.selectedChat!.touser;
      final eventFromUser = int.tryParse(
          data['fromuser']?.toString() ?? data['fromUser']?.toString() ?? '');
      if (targetUserId != null && targetUserId == eventFromUser) {
        emit(state.copyWith(
          selectedChat: state.selectedChat!.copyWith(
            isClosed: isClosedVal,
            isAssigned: !isClosedVal && toUser != null && toUser > 0,
          ),
        ));
      }
    }
  }

  void reset() {
    if (!isClosed) {
      emit(const AdminChatState());
    }
  }

  void _startBackgroundListPolling() {
    _backgroundListPollTimer?.cancel();
    _backgroundListPollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchSupportConversations(silent: true);
    });
  }

  void _startActiveChatPolling() {
    _stopActiveChatPolling();
    _activeChatPollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pollActiveChatMessages();
    });
  }

  void _stopActiveChatPolling() {
    _activeChatPollTimer?.cancel();
    _activeChatPollTimer = null;
  }

  Future<void> _pollActiveChatMessages() async {
    final chat = state.selectedChat;
    if (chat == null || isClosed) return;

    final partner = _getPartner(chat);
    final targetId = partner.$1;
    final targetType = partner.$2;
    if (targetId == 0 || targetType == 0) return;

    try {
      final fetched = await chatRepository.getChatMessages(
        fromUserId: currentUserId,
        fromUserType: currentUserType,
        toUserId: targetId,
        toUserType: targetType,
        isClosed: chat.isClosed ? true : null,
      );

      if (isClosed || state.selectedChat == null) return;
      final currentChat = state.selectedChat!;
      final currentPartner = _getPartner(currentChat);
      if (currentPartner.$1 != targetId || currentPartner.$2 != targetType) {
        return;
      }

      if (fetched.isEmpty) return;

      final currentMsgs =
          List<ChatMessageModel>.from(currentChat.messages ?? []);
      bool addedAny = false;

      for (final msg in fetched) {
        final existingIndex = currentMsgs.indexWhere(
          (m) => _isSameOrOptimistic(m, msg),
        );
        final effectiveMsg = msg.copyWith(viewed: true);
        if (existingIndex >= 0) {
          if (currentMsgs[existingIndex].id == 0) {
            currentMsgs[existingIndex] = effectiveMsg;
            addedAny = true;
          }
        } else {
          currentMsgs.add(effectiveMsg);
          addedAny = true;
        }
      }

      if (addedAny) {
        final updatedChat = currentChat.copyWith(
          messages: currentMsgs,
          unViewedMessagesCount: 0,
          directLastMessage: currentMsgs.isNotEmpty
              ? currentMsgs.last
              : currentChat.directLastMessage,
        );

        bool matchesTarget(GetAllMessagesModel c) =>
            _isSameConversation(c, chat);

        final updatedMyTickets = state.myTickets
            .map((c) => matchesTarget(c) ? updatedChat : c)
            .toList();
        final updatedUnassigned = state.unassignedTickets
            .map((c) => matchesTarget(c) ? updatedChat : c)
            .toList();
        final updatedClosed = state.closedTickets
            .map((c) => matchesTarget(c) ? updatedChat : c)
            .toList();

        List<GetAllMessagesModel> activeTabList;
        switch (state.ticketTab) {
          case TicketTab.unassigned:
            activeTabList = updatedUnassigned;
            break;
          case TicketTab.mine:
            activeTabList = updatedMyTickets;
            break;
          case TicketTab.closed:
            activeTabList = updatedClosed;
            break;
        }

        emit(state.copyWith(
          selectedChat: updatedChat,
          myTickets: updatedMyTickets,
          unassignedTickets: updatedUnassigned,
          closedTickets: updatedClosed,
          allMessages: activeTabList,
          filteredMessages: _applySearch(activeTabList, state.searchQuery),
        ));

        markChatViewed(targetId, targetType);
      }
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _stopActiveChatPolling();
    _backgroundListPollTimer?.cancel();
    _backgroundListPollTimer = null;
    _chatEventsSub?.cancel();
    return super.close();
  }
}
