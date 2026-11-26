import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';

class ChatEmptyView extends StatelessWidget {
  const ChatEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 40,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isAr
                  ? LocaleKeys.selectConversationToStart.tr()
                  : 'Select a conversation to start chatting',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.appBlackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAr
                  ? LocaleKeys.chatWithClientsAndProviders.tr()
                  : 'You can communicate with customers, providers, and your team here',
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
