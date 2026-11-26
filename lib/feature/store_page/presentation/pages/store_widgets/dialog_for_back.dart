import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';

Future<bool?> showBackDialog({required BuildContext context}) {
  Size size = MediaQuery.of(context).size;
  bool isMobile = size.width < ValuesOfAllApp.mobileWidth ? true : false;
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        title: SizedBox(
          width: isMobile ? size.width : 300,
          child: const Center(
              child: TextInAppWidget(
                  text: LocaleKeys.common_confirm_exit,
                  textAlign: TextAlign.center,
                  fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                  textSize: 20)),
        ),
        content: SizedBox(
          height: 50,
          width: isMobile ? size.width : 300,
          child: const Center(
              child: TextInAppWidget(
                  text: LocaleKeys.common_are_you_sure_to_leave,
                  textAlign: TextAlign.center,
                  fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                  textSize: 20)),
        ),
        actions: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const TextInAppWidget(
                      text: LocaleKeys.Ok,
                      textAlign: TextAlign.center,
                      fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                      textSize: 15),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const TextInAppWidget(
                      text: LocaleKeys.cancel,
                      textAlign: TextAlign.center,
                      fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                      textSize: 15),
                ),
              ]),
        ],
      );
    },
  );
}
