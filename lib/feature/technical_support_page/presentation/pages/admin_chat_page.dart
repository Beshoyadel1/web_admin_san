import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/di/sl.dart';
import '../../../../core/helpers/colors/app_colors.dart';
import '../../view_model/admin_chat_cubit/admin_chat_cubit.dart';
import '../../view_model/admin_chat_cubit/admin_chat_state.dart';
import 'widgets/chat_conversations_panel.dart';
import 'widgets/chat_thread_panel.dart';
import 'widgets/chat_work_team_panel.dart';

class TechnicalSupportPage extends StatefulWidget {
  const TechnicalSupportPage({super.key});

  @override
  State<TechnicalSupportPage> createState() => _TechnicalSupportPageState();
}

class _TechnicalSupportPageState extends State<TechnicalSupportPage> {
  @override
  void initState() {
    super.initState();
    final cubit = getIt<AdminChatCubit>();
    cubit.clearSelectedChat();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AdminChatCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 768) {
              return const _MobileChatLayout();
            } else if (constraints.maxWidth < 1100) {
              return const _TabletChatLayout();
            } else {
              return const _DesktopChatLayout();
            }
          },
        ),
      ),
    );
  }
}

class _DesktopChatLayout extends StatelessWidget {
  const _DesktopChatLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 340, child: ChatConversationsPanel()),
        Expanded(child: ChatThreadPanel()),
        SizedBox(width: 280, child: ChatWorkTeamPanel()),
      ],
    );
  }
}

class _TabletChatLayout extends StatelessWidget {
  const _TabletChatLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 300, child: ChatConversationsPanel()),
        Expanded(child: ChatThreadPanel()),
      ],
    );
  }
}

class _MobileChatLayout extends StatelessWidget {
  const _MobileChatLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminChatCubit, AdminChatState>(
      buildWhen: (prev, curr) => prev.selectedChat != curr.selectedChat,
      builder: (context, state) {
        final cubit = context.read<AdminChatCubit>();
        final hasSelectedChat = state.selectedChat != null;

        return PopScope(
          canPop: !hasSelectedChat,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (hasSelectedChat) {
              cubit.clearSelectedChat();
            }
          },
          child: hasSelectedChat
              ? ChatThreadPanel(
                  showBackButton: true,
                  onBack: () => cubit.clearSelectedChat(),
                )
              : const ChatConversationsPanel(),
        );
      },
    );
  }
}
