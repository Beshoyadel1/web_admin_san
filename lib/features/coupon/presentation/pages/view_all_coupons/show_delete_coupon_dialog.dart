import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

import '../../../../../core/theming/colors.dart';

Future<bool?> showDeleteCouponDialog(
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
          text: AppLanguageKeys.delete,
          textSize: 20,
          textColor: Colors.red,
          isTextCenter: true,
        ),
        content: const TextInAppWidget(
          text: AppLanguageKeys.areYouSure,
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
              text: AppLanguageKeys.cancel,
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
              text: AppLanguageKeys.delete,
              textSize: 14,
              textColor: AppColors.whiteColor,
            ),
          ),
        ],
      );
    },
  );
}
