import 'package:flutter/material.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../features/cars_haraj_page/data/model/get_all_harage_model/chat_harag_model.dart';
import '../../../../../../../features/cars_haraj_page/data/model/get_all_harage_model/harage_data.dart';

class WidgetDesignChatsHarag extends StatelessWidget {
  const WidgetDesignChatsHarag({
    super.key,
    required this.harage,
  });

  final HarageData harage;

  @override
  Widget build(BuildContext context) {
    final chats = harage.chats;

    return CustomContainer(
      isSelected: false,
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      typeWidget: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextInAppWidget(
              text: AppLanguageKeys.messages,
              textSize: 18,
              fontWeightIndex:
              FontSelectionData.mediumFontFamily,
              textColor: AppColors.darkColor,
            ),

            const SizedBox(height: 15),

            if (chats.isEmpty)
              const TextInAppWidget(
                text: AppLanguageKeys.empty,
                textSize: 14,
                fontWeightIndex:
                FontSelectionData.mediumFontFamily,
                textColor: AppColors.greyColor,
              )
            else
              ...chats.map(
                    (chat) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildChatItem(
                    context,
                    chat,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(
      BuildContext context,
      ChatHaragModel chat,
      ) {
    final image =
        chat.fromUserImage ?? chat.toUserImage;

    final userName =
        chat.fromUserName ??
            chat.toUserName ??
            '---';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(.2),
        ),
      ),
      child: Row(
        children: [
          image != null
              ? CircleAvatar(
            radius: 22,
            backgroundImage: MemoryImage(image),
          )
              : const CircleAvatar(
            radius: 22,
            child: Icon(
              Icons.person_outline,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                TextInAppWidget(
                  text: userName,
                  textSize: 14,
                  fontWeightIndex:
                  FontSelectionData.mediumFontFamily,
                  textColor: AppColors.darkColor,
                  maxLines: 1,
                ),

                const SizedBox(height: 5),

                TextInAppWidget(
                  text: chat.lastMessage ?? '---',
                  textSize: 12,
                  fontWeightIndex:
                  FontSelectionData.regularFontFamily,
                  textColor: AppColors.greyColor,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          if ((chat.notViewedCount ?? 0) > 0)
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: TextInAppWidget(
                  text: '${chat.notViewedCount}',
                  textSize: 10,
                  fontWeightIndex:
                  FontSelectionData.mediumFontFamily,
                  textColor: AppColors.whiteColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}