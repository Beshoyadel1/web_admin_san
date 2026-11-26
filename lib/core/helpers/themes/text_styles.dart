import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/core/helpers/themes/fonts.dart' show AppFonts;
import '../fontSelection/font_selection.dart';

class TextInAppWidget extends StatefulWidget {
  const TextInAppWidget(
      {super.key,
      required this.text,
      this.textColor,
      this.textSize,
      this.textWidth,
      this.isTextCenter,
      this.textAlign,
      this.fontWeightIndex,
      this.isEllipsisTextOverflow,
      this.maxLines,
      this.decorationTextColor,
      this.decorationText = TextDecoration.none});

  final String text;

  final Color? textColor;

  final double? textSize;

  final double? textWidth;

  final bool? isTextCenter;

  final TextAlign? textAlign;

  final int? fontWeightIndex;

  final bool? isEllipsisTextOverflow;

  final int? maxLines;

  final TextDecoration decorationText;

  final Color? decorationTextColor;

  @override
  State<TextInAppWidget> createState() => _TextInAppWidgetState();
}

class _TextInAppWidgetState extends State<TextInAppWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isArabic = true;
    try {
      isArabic = context.locale.languageCode == 'ar';
    } catch (_) {
      isArabic = Localizations.maybeLocaleOf(context)?.languageCode != 'en';
    }

    return SizedBox(
      width: widget.textWidth,
      child: Text(widget.text.tr(),
          textAlign: widget.textAlign ??
              (widget.isTextCenter == true
                  ? TextAlign.center
                  : TextAlign.start),
          maxLines: widget.maxLines,
          style: TextStyle(
            overflow: widget.isEllipsisTextOverflow == true
                ? TextOverflow.ellipsis
                : null,
            fontSize: widget.textSize != null
                ? (isArabic ? widget.textSize : widget.textSize! - 2)
                : (isArabic ? size.width * 0.05 : size.width * 0.04),
            fontWeight:
                fontWeightSelection(fontWeightIndex: widget.fontWeightIndex),
            color: widget.textColor,
            fontFamily: fontSelection(),
            fontFamilyFallback: AppFonts.fontFallbacks,
            decoration: widget.decorationText,
            decorationColor: widget.decorationTextColor,
            decorationThickness: 1.5,
          )),
    );
  }
}
