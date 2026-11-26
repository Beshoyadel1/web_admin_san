import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../core/helpers/themes/text_styles.dart';

import '../../../../../core/helpers/colors/app_colors.dart';

Future<bool?> showDeleteConfirmationDialogInApp(
  BuildContext context,
) {
  return showDialog<bool>(
    context: context,
    builder: (
      dialogContext,
    ) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const TextInAppWidget(
          text: LocaleKeys.delete,
          textSize: 20,
          textColor: Colors.red,
          isTextCenter: true,
        ),
        content: const TextInAppWidget(
          text: LocaleKeys.areYouSure,
          textSize: 15,
          textColor: AppColors.darkColor,
          isTextCenter: true,
        ),
        actions: [
          // =========================================
          // CANCEL
          // =========================================

          TextButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                false,
              );
            },
            child: const TextInAppWidget(
              text: LocaleKeys.cancel,
              textSize: 14,
              textColor: AppColors.greyColor,
            ),
          ),

          // =========================================
          // DELETE
          // =========================================

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(
                dialogContext,
                true,
              );
            },
            child: const TextInAppWidget(
              text: LocaleKeys.delete,
              textSize: 14,
              textColor: AppColors.whiteColor,
            ),
          ),
        ],
      );
    },
  );
}
