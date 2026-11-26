import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:web_admin_san/feature/technical_support_page/view_model/admin_chat_cubit/admin_chat_state.dart';
import 'package:web_admin_san/feature/technical_support_page/data/model/admin_chat_model.dart';
import 'work_team_member_tile.dart';

class ChatWorkTeamPanel extends StatefulWidget {
  final ValueChanged<GetAllMessagesModel>? onSelectMember;

  const ChatWorkTeamPanel({super.key, this.onSelectMember});

  @override
  State<ChatWorkTeamPanel> createState() => _ChatWorkTeamPanelState();
}

class _ChatWorkTeamPanelState extends State<ChatWorkTeamPanel> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminChatCubit, AdminChatState>(
      builder: (context, state) {
        final cubit = context.read<AdminChatCubit>();
        final members = state.workTeam;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            border: BorderDirectional(
              start: BorderSide(color: AppColors.cardStroke),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.workTeamTitle.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appBlackColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardStroke),
                      ),
                      child: Text(
                        members.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh,
                          color: AppColors.appGrey, size: 20),
                      onPressed: () => cubit.getWorkTeam(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.cardStroke),
              Expanded(
                child: state.isLoadingWorkTeam && members.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: members.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final member = members[index];
                            return WorkTeamMemberTile(
                              member: member,
                              onTap: () {
                                final langCode = Localizations.localeOf(context)
                                    .languageCode;
                                final targetUserId = member.userid ?? 0;
                                final targetUserType = member.usertype ?? 0;

                                GetAllMessagesModel? targetChat;
                                for (final e in state.allMessages) {
                                  final matchesUser =
                                      e.touser == targetUserId &&
                                          e.tousertype == targetUserType;
                                  if (matchesUser) {
                                    targetChat = e;
                                    break;
                                  }
                                }

                                targetChat ??= GetAllMessagesModel(
                                  touser: targetUserId,
                                  tousertype: targetUserType,
                                  userName: member.getLocalizedName(langCode),
                                  messages: [],
                                  noOldMessages: true,
                                  image: member.image,
                                );

                                cubit.selectChat(targetChat);
                                widget.onSelectMember?.call(targetChat);
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
