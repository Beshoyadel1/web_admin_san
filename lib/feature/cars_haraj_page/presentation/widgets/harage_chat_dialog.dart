import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_harage_chat_model/get_harage_chat_model.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_cubit.dart';
import 'package:web_admin_san/feature/cars_haraj_page/view_model/harag_cubit/harag_state.dart';

class HarageChatDialog extends StatefulWidget {
  final int harageId;
  final String? title;

  const HarageChatDialog({
    super.key,
    required this.harageId,
    this.title,
  });

  @override
  State<HarageChatDialog> createState() => _HarageChatDialogState();
}

class _HarageChatDialogState extends State<HarageChatDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HaragCubit>().getHarageChat(
              harageId: widget.harageId,
            );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    final dialogWidth = width > 700 ? 650.0 : width * 0.92;
    final dialogHeight = height > 800 ? 680.0 : height * 0.85;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.whiteColor,
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          children: [
            // ========================================================
            // HEADER
            // ========================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.whiteGreyColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.greyColor.withOpacity(0.15),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.orangeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextInAppWidget(
                          text: widget.title ?? LocaleKeys.haragMessages.tr(),
                          textSize: 16,
                          fontWeightIndex: FontSelectionData.boldFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                        const SizedBox(height: 2),
                        TextInAppWidget(
                          text: LocaleKeys.haragMessagesSubtitle.tr(),
                          textSize: 12,
                          textColor: AppColors.darkGreyColor,
                        ),
                      ],
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.greyColor,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // ========================================================
            // MESSAGES LIST
            // ========================================================
            Expanded(
              child: BlocBuilder<HaragCubit, HaragState>(
                buildWhen: (previous, current) =>
                    current is GetHarageChatLoading ||
                    current is GetHarageChatSuccess ||
                    current is GetHarageChatError,
                builder: (context, state) {
                  final cubit = context.read<HaragCubit>();

                  if (state is GetHarageChatLoading &&
                      cubit.harageChatResponse == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orangeColor,
                      ),
                    );
                  }

                  if (state is GetHarageChatError &&
                      cubit.harageChatResponse == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 45,
                              color: AppColors.redColor,
                            ),
                            const SizedBox(height: 12),
                            TextInAppWidget(
                              text: state.message,
                              textSize: 14,
                              textColor: AppColors.darkGreyColor,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orangeColor,
                                foregroundColor: AppColors.whiteColor,
                              ),
                              onPressed: () {
                                cubit.getHarageChat(
                                  harageId: widget.harageId,
                                );
                              },
                              child: TextInAppWidget(
                                text: LocaleKeys.retry.tr(),
                                textSize: 13,
                                textColor: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final response = cubit.harageChatResponse;
                  final messages = response?.data?.messages ?? [];
                  final contributors = response?.data?.contributors ?? [];

                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 50,
                            color: AppColors.greyColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          TextInAppWidget(
                            text: LocaleKeys.noMessagesForListing.tr(),
                            textSize: 15,
                            fontWeightIndex: FontSelectionData.mediumFontFamily,
                            textColor: AppColors.darkGreyColor,
                          ),
                        ],
                      ),
                    );
                  }

                  return Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final contributor = _findContributor(
                          msg,
                          contributors,
                        );

                        return _HarageChatMessageBubble(
                          message: msg,
                          contributor: contributor,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  GetHarageChatContributor? _findContributor(
    GetHarageChatMessage message,
    List<GetHarageChatContributor> contributors,
  ) {
    if (contributors.isEmpty) return null;

    final fromId = message.fromUser;
    final fromType = message.fromUserType;

    for (final c in contributors) {
      if (c.userId == fromId && c.userType == fromType) {
        return c;
      }
    }

    for (final c in contributors) {
      if (c.userId == fromId) {
        return c;
      }
    }

    return null;
  }
}

class _HarageChatMessageBubble extends StatelessWidget {
  final GetHarageChatMessage message;
  final GetHarageChatContributor? contributor;

  const _HarageChatMessageBubble({
    required this.message,
    required this.contributor,
  });

  @override
  Widget build(BuildContext context) {
    final senderName = contributor?.name?.isNotEmpty == true
        ? contributor!.name!
        : LocaleKeys.userDefault.tr();
    final image = contributor?.image;
    final dateStr = message.date != null
        ? DateFormat('yyyy/MM/dd - hh:mm a').format(message.date!)
        : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image != null
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: MemoryImage(image),
                )
              : CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.orangeColor.withOpacity(0.15),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.orangeColor,
                    size: 20,
                  ),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextInAppWidget(
                      text: senderName,
                      textSize: 14,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.darkColor,
                    ),
                    if (dateStr.isNotEmpty)
                      TextInAppWidget(
                        text: dateStr,
                        textSize: 11,
                        textColor: AppColors.greyColor,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.12),
                    ),
                  ),
                  child: TextInAppWidget(
                    text: message.message ?? '',
                    textSize: 13,
                    textColor: AppColors.darkColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
