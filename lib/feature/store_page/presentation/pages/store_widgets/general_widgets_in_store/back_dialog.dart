import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

Future<bool?> showBackDialog({required BuildContext context}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        title: SizedBox(
          width: 300,
          child: Center(
            child: Text(
              LocaleKeys.common_confirm_exit.tr(),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        content: SizedBox(
          height: 50,
          width: 300,
          child: Center(
            child: Text(
              LocaleKeys.common_are_you_sure_to_leave.tr(),
              softWrap: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkColor,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(LocaleKeys.Ok.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(LocaleKeys.cancel.tr()),
              ),
            ],
          ),
        ],
      );
    },
  );
}
