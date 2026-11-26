import 'package:equatable/equatable.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/admin_chat_model.dart';

enum ConversationTab {
  unassigned, // محادثات جديدة (غير مسندة)
  mine, // محادثاتي (المسندة للأدمن الحالي)
  closed, // محادثات مغلقة
}

// Backward-compatibility alias
typedef TicketTab = ConversationTab;

class AdminChatState extends Equatable {
  final List<GetAllMessagesModel> allMessages;
  final List<GetAllMessagesModel> filteredMessages;
  final List<GetAllMessagesModel> unassignedConversations;
  final List<GetAllMessagesModel> myConversations;
  final List<GetAllMessagesModel> closedConversations;
  final List<WorkTeamMemberModel> workTeam;
  final GetAllMessagesModel? selectedChat;
  final int selectedTab; // 0 = Messages, 1 = Work Team
  final ConversationTab conversationTab;
  final String searchQuery;
  final bool isLoadingMessages;
  final bool isLoadingWorkTeam;
  final bool isSendingMessage;
  final bool isLoadingOlder;
  final bool isPerformingConversationAction;
  final String? errorMessage;
  final String? conversationActionError;
  final String? conversationActionSuccess;

  const AdminChatState({
    this.allMessages = const [],
    this.filteredMessages = const [],
    this.unassignedConversations = const [],
    this.myConversations = const [],
    this.closedConversations = const [],
    this.workTeam = const [],
    this.selectedChat,
    this.selectedTab = 0,
    this.conversationTab = ConversationTab.unassigned,
    this.searchQuery = '',
    this.isLoadingMessages = false,
    this.isLoadingWorkTeam = false,
    this.isSendingMessage = false,
    this.isLoadingOlder = false,
    this.isPerformingConversationAction = false,
    this.errorMessage,
    this.conversationActionError,
    this.conversationActionSuccess,
  });

  // Backward compatibility getters
  List<GetAllMessagesModel> get unassignedTickets => unassignedConversations;
  List<GetAllMessagesModel> get myTickets => myConversations;
  List<GetAllMessagesModel> get closedTickets => closedConversations;
  ConversationTab get ticketTab => conversationTab;
  bool get isPerformingTicketAction => isPerformingConversationAction;
  String? get ticketActionError => conversationActionError;
  String? get ticketActionSuccess => conversationActionSuccess;
  List<GetAllMessagesModel> get currentTabTickets => currentTabConversations;
  int get unassignedTicketsCount => unassignedConversations.length;
  int get myTicketsCount => myConversations.length;
  int get closedTicketsCount => closedConversations.length;

  AdminChatState copyWith({
    List<GetAllMessagesModel>? allMessages,
    List<GetAllMessagesModel>? filteredMessages,
    List<GetAllMessagesModel>? unassignedConversations,
    List<GetAllMessagesModel>? myConversations,
    List<GetAllMessagesModel>? closedConversations,
    List<GetAllMessagesModel>? unassignedTickets,
    List<GetAllMessagesModel>? myTickets,
    List<GetAllMessagesModel>? closedTickets,
    List<WorkTeamMemberModel>? workTeam,
    GetAllMessagesModel? selectedChat,
    bool clearSelectedChat = false,
    int? selectedTab,
    ConversationTab? conversationTab,
    ConversationTab? ticketTab,
    String? searchQuery,
    bool? isLoadingMessages,
    bool? isLoadingWorkTeam,
    bool? isSendingMessage,
    bool? isLoadingOlder,
    bool? isPerformingConversationAction,
    bool? isPerformingTicketAction,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? conversationActionError,
    bool clearConversationActionError = false,
    String? conversationActionSuccess,
    bool clearConversationActionSuccess = false,
    String? ticketActionError,
    bool clearTicketActionError = false,
    String? ticketActionSuccess,
    bool clearTicketActionSuccess = false,
  }) {
    return AdminChatState(
      allMessages: allMessages ?? this.allMessages,
      filteredMessages: filteredMessages ?? this.filteredMessages,
      unassignedConversations: unassignedConversations ??
          unassignedTickets ??
          this.unassignedConversations,
      myConversations: myConversations ?? myTickets ?? this.myConversations,
      closedConversations:
          closedConversations ?? closedTickets ?? this.closedConversations,
      workTeam: workTeam ?? this.workTeam,
      selectedChat:
          clearSelectedChat ? null : (selectedChat ?? this.selectedChat),
      selectedTab: selectedTab ?? this.selectedTab,
      conversationTab: conversationTab ?? ticketTab ?? this.conversationTab,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isLoadingWorkTeam: isLoadingWorkTeam ?? this.isLoadingWorkTeam,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isLoadingOlder: isLoadingOlder ?? this.isLoadingOlder,
      isPerformingConversationAction: isPerformingConversationAction ??
          isPerformingTicketAction ??
          this.isPerformingConversationAction,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      conversationActionError:
          (clearConversationActionError || clearTicketActionError)
              ? null
              : (conversationActionError ??
                  ticketActionError ??
                  this.conversationActionError),
      conversationActionSuccess:
          (clearConversationActionSuccess || clearTicketActionSuccess)
              ? null
              : (conversationActionSuccess ??
                  ticketActionSuccess ??
                  this.conversationActionSuccess),
    );
  }

  /// Returns the conversation list for the currently selected conversation tab.
  List<GetAllMessagesModel> get currentTabConversations {
    switch (conversationTab) {
      case ConversationTab.unassigned:
        return unassignedConversations;
      case ConversationTab.mine:
        return myConversations;
      case ConversationTab.closed:
        return closedConversations;
    }
  }

  int get unassignedCount => unassignedConversations.length;
  int get myConversationsCount => myConversations.length;
  int get closedConversationsCount => closedConversations.length;

  int calculateTotalUnread(int currentUserId, int currentUserType) {
    int count = unassignedConversations.length;
    for (final chat in myConversations) {
      if (selectedChat != null &&
          selectedChat!.touser == chat.touser &&
          selectedChat!.tousertype == chat.tousertype) {
        continue;
      }
      count += chat.unreadCount(currentUserId, currentUserType);
    }
    return count;
  }

  int get totalUnreadCount => calculateTotalUnread(0, 0);

  @override
  List<Object?> get props => [
        allMessages,
        filteredMessages,
        unassignedConversations,
        myConversations,
        closedConversations,
        workTeam,
        selectedChat,
        selectedTab,
        conversationTab,
        searchQuery,
        isLoadingMessages,
        isLoadingWorkTeam,
        isSendingMessage,
        isLoadingOlder,
        isPerformingConversationAction,
        errorMessage,
        conversationActionError,
        conversationActionSuccess,
      ];
}
