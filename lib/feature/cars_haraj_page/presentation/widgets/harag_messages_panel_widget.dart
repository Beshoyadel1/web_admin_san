import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/themes/fonts.dart';
import 'package:web_admin_san/core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/core/widgets/custom_container.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';
import 'package:web_admin_san/feature/cars_haraj_page/data/model/get_harage_chat_model/get_harage_chat_model.dart';

class HaragMessagesPanelWidget extends StatefulWidget {
  final HarageData harage;
  final List<GetHarageChatMessage> liveMessages;

  const HaragMessagesPanelWidget({
    super.key,
    required this.harage,
    this.liveMessages = const [],
  });

  @override
  State<HaragMessagesPanelWidget> createState() =>
      _HaragMessagesPanelWidgetState();
}

class _HaragMessagesPanelWidgetState extends State<HaragMessagesPanelWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_MessageDisplayItem> items = [];

    // 1. Prefer harage.chats if present
    if (widget.harage.chats.isNotEmpty) {
      for (final c in widget.harage.chats) {
        items.add(
          _MessageDisplayItem(
            text: c.lastMessage ?? LocaleKeys.incomingMessage.tr(),
            date: c.lastMessageDate,
            badgeCount: c.notViewedCount,
          ),
        );
      }
    } else if (widget.liveMessages.isNotEmpty) {
      // 2. Fallback to liveMessages from GetHarageChatResponse
      for (final m in widget.liveMessages.reversed) {
        items.add(
          _MessageDisplayItem(
            text: m.message ?? '',
            date: m.date,
            badgeCount: (m.viewed == false) ? 1 : null,
          ),
        );
      }
    }

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      typeWidget: Container(
        constraints: const BoxConstraints(
          minHeight: 380,
          maxHeight: 560,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ========================================================
            // HEADER: "الرسائل" Title & Counter
            // ========================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextInAppWidget(
                  text: LocaleKeys.messagesTitle.tr(),
                  textSize: 18,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.darkColor,
                ),
                if (items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orangeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextInAppWidget(
                      text: '${items.length}',
                      textSize: 12,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                      textColor: AppColors.orangeColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // ========================================================
            // MESSAGES LIST
            // ========================================================
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 42,
                            color: AppColors.greyColor.withOpacity(0.4),
                          ),
                          const SizedBox(height: 10),
                          TextInAppWidget(
                            text: LocaleKeys.noMessagesForCar.tr(),
                            textSize: 13,
                            textColor: AppColors.greyColor,
                          ),
                        ],
                      ),
                    )
                  : Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return _HaragMessageItemCard(
                            item: item,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageDisplayItem {
  final String text;
  final DateTime? date;
  final int? badgeCount;

  const _MessageDisplayItem({
    required this.text,
    this.date,
    this.badgeCount,
  });
}

class _HaragMessageItemCard extends StatelessWidget {
  final _MessageDisplayItem item;

  const _HaragMessageItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(item.date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // 1. Leading circular orange icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.orangeColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.orangeColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // 2. Message snippet and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInAppWidget(
                  text: item.text.isNotEmpty
                      ? item.text
                      : LocaleKeys.singleMessage.tr(),
                  textSize: 14,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.darkColor,
                  maxLines: 1,
                ),
                if (dateStr.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  TextInAppWidget(
                    text: dateStr,
                    textSize: 11,
                    textColor: AppColors.greyColor,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),

          // 3. Trailing unread count badge
          if (item.badgeCount != null && item.badgeCount! > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(
                minWidth: 22,
                minHeight: 22,
              ),
              decoration: const BoxDecoration(
                color: AppColors.orangeColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: TextInAppWidget(
                  text: '${item.badgeCount}',
                  textSize: 11,
                  fontWeightIndex: FontSelectionData.boldFontFamily,
                  textColor: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    try {
      return DateFormat('d MMMM - h:mm a', 'ar').format(date);
    } catch (_) {
      return DateFormat('yyyy/MM/dd - h:mm a').format(date);
    }
  }
}
