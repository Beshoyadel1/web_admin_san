import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/setup_git_it.dart';
import '../../../../core/theming/colors.dart';
import '../bloc/admin_chat_cubit/admin_chat_cubit.dart';
import '../bloc/admin_chat_cubit/admin_chat_state.dart';
import 'widgets/chat_conversations_panel.dart';
import 'widgets/chat_thread_panel.dart';
import 'widgets/chat_work_team_panel.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
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
            if (constraints.maxWidth < 600) {
              return const _MobileChatLayout();
            } else if (constraints.maxWidth < 1024) {
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
        SizedBox(width: 340, child: ChatConversationsPanel()),
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
        if (state.selectedChat != null) {
          return const ChatThreadPanel(showBackButton: true);
        }
        return const ChatConversationsPanel();
      },
    );
  }
}
