import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_state.dart';
import '../../../data/model/admin_chat_model.dart';
import 'chat_conversation_tile.dart';
import 'chat_search_field.dart';

class ChatConversationsPanel extends StatefulWidget {
  final ValueChanged<GetAllMessagesModel>? onSelectChat;

  const ChatConversationsPanel({super.key, this.onSelectChat});

  @override
  State<ChatConversationsPanel> createState() => _ChatConversationsPanelState();
}

class _ChatConversationsPanelState extends State<ChatConversationsPanel> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminChatCubit, AdminChatState>(
      builder: (context, state) {
        final cubit = context.read<AdminChatCubit>();
        final conversations = state.searchQuery.isNotEmpty
            ? state.filteredMessages
            : state.currentTabTickets;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            border: BorderDirectional(
              end: BorderSide(color: AppColors.cardStroke),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys.supportCenter.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appBlackColor,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColors.appGrey,
                            size: 20,
                          ),
                          tooltip: LocaleKeys.reloadTooltip.tr(),
                          onPressed: () => cubit.fetchSupportConversations(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TicketTabBar(
                      activeTab: state.ticketTab,
                      unassignedCount: state.unassignedCount,
                      myTicketsCount: state.myTicketsCount,
                      closedTicketsCount: state.closedTicketsCount,
                      onTabChanged: (tab) => cubit.changeTicketTab(tab),
                    ),
                    const SizedBox(height: 12),
                    ChatSearchField(
                      controller: _searchController,
                      onChanged: (val) => cubit.searchMessages(val),
                      onClear: () {
                        _searchController.clear();
                        cubit.searchMessages('');
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.cardStroke),
              Expanded(
                child: state.isLoadingMessages &&
                        state.currentTabTickets.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      )
                    : conversations.isEmpty
                        ? _ConversationsEmptyView(
                            tab: state.ticketTab,
                            isSearching: state.searchQuery.isNotEmpty,
                          )
                        : Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView.separated(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              itemCount: conversations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                final chat = conversations[index];
                                final isSelected = state.selectedChat != null &&
                                    cubit.isSameConversation(
                                        state.selectedChat!, chat);

                                return ChatConversationTile(
                                  chat: chat,
                                  isSelected: isSelected,
                                  currentUserId: cubit.currentUserId,
                                  currentUserType: cubit.currentUserType,
                                  onTap: () {
                                    cubit.selectChat(chat);
                                    widget.onSelectChat?.call(chat);
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TicketTabBar extends StatelessWidget {
  final TicketTab activeTab;
  final int unassignedCount;
  final int myTicketsCount;
  final int closedTicketsCount;
  final ValueChanged<TicketTab> onTabChanged;

  const _TicketTabBar({
    required this.activeTab,
    required this.unassignedCount,
    required this.myTicketsCount,
    required this.closedTicketsCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TicketTabButton(
              title: LocaleKeys.newBadge.tr(),
              count: unassignedCount,
              isActive: activeTab == TicketTab.unassigned,
              highlightBadge: unassignedCount > 0,
              onTap: () => onTabChanged(TicketTab.unassigned),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TicketTabButton(
              title: LocaleKeys.myTickets.tr(),
              count: myTicketsCount,
              isActive: activeTab == TicketTab.mine,
              highlightBadge: false,
              onTap: () => onTabChanged(TicketTab.mine),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TicketTabButton(
              title: LocaleKeys.closedStatus.tr(),
              count: closedTicketsCount,
              isActive: activeTab == TicketTab.closed,
              highlightBadge: false,
              onTap: () => onTabChanged(TicketTab.closed),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketTabButton extends StatelessWidget {
  final String title;
  final int count;
  final bool isActive;
  final bool highlightBadge;
  final VoidCallback onTap;

  const _TicketTabButton({
    required this.title,
    required this.count,
    required this.isActive,
    required this.highlightBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.whiteColor : AppColors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.appBlackColor.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? AppColors.mainColor
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _TabBadge(
                count: count,
                isActive: isActive,
                highlightBadge: highlightBadge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBadge extends StatelessWidget {
  final int count;
  final bool isActive;
  final bool highlightBadge;

  const _TabBadge({
    required this.count,
    required this.isActive,
    required this.highlightBadge,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = highlightBadge
        ? AppColors.orangeColor
        : (isActive ? AppColors.mainColor : AppColors.veryLightGreyColor);

    final textColor = (highlightBadge || isActive)
        ? AppColors.whiteColor
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class _ConversationsEmptyView extends StatelessWidget {
  final TicketTab tab;
  final bool isSearching;

  const _ConversationsEmptyView({
    required this.tab,
    required this.isSearching,
  });

  String _getMessage(BuildContext context) {
    if (isSearching) {
      return LocaleKeys.noMatchingTickets.tr();
    }
    switch (tab) {
      case ConversationTab.unassigned:
        return LocaleKeys.noTicketsWaitingAcceptance.tr();
      case ConversationTab.mine:
        return LocaleKeys.noActiveTickets.tr();
      case ConversationTab.closed:
        return LocaleKeys.noClosedTickets.tr();
    }
  }

  IconData _getIcon() {
    if (isSearching) return Icons.search_off_rounded;
    switch (tab) {
      case TicketTab.unassigned:
        return Icons.inbox_outlined;
      case TicketTab.mine:
        return Icons.chat_bubble_outline_rounded;
      case TicketTab.closed:
        return Icons.archive_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: 44,
              color: AppColors.appGrey,
            ),
            const SizedBox(height: 12),
            Text(
              _getMessage(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
