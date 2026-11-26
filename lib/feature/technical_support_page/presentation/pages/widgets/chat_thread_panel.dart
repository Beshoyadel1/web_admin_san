import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_state.dart';
import 'chat_compose_bar.dart';
import 'chat_empty_view.dart';
import 'chat_messages_scroll_view.dart';
import 'chat_thread_header.dart';

class ChatThreadPanel extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBack;

  const ChatThreadPanel({
    super.key,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminChatCubit, AdminChatState>(
      listenWhen: (prev, curr) =>
          prev.ticketActionSuccess != curr.ticketActionSuccess ||
          prev.ticketActionError != curr.ticketActionError,
      listener: (context, state) {
        if (state.ticketActionSuccess != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.ticketActionSuccess!),
              backgroundColor: AppColors.greenColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state.ticketActionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.ticketActionError!),
              backgroundColor: AppColors.errorRedColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      child: BlocBuilder<AdminChatCubit, AdminChatState>(
        builder: (context, state) {
          final cubit = context.read<AdminChatCubit>();
          final activeChat = state.selectedChat;

          if (activeChat == null) {
            return Container(
              color: AppColors.whiteColor,
              child: const ChatEmptyView(),
            );
          }

          return Container(
            color: AppColors.whiteColor,
            child: Column(
              children: [
                ChatThreadHeader(
                  chat: activeChat,
                  showBackButton: showBackButton,
                  onBack: onBack ?? () => cubit.clearSelectedChat(),
                ),
                Expanded(
                  child: ChatMessagesScrollView(
                    messages: activeChat.messages ?? [],
                    noOldMessages: activeChat.noOldMessages,
                    isLoadingOlder: state.isLoadingOlder,
                    onLoadOlder: () => cubit.getOlderMessages(),
                    currentUserId: cubit.currentUserId,
                    currentUserType: cubit.currentUserType,
                  ),
                ),
                ChatComposeBar(
                  isSending: state.isSendingMessage,
                  onSend: (text) => cubit.sendMessage(text),
                  isClosed: activeChat.isClosed,
                  isAssigned: activeChat.isAssigned,
                  isPerformingAction: state.isPerformingTicketAction,
                  onAcceptTicket: () => cubit.acceptTicket(activeChat),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
