import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';

class TextEmptyViewData extends StatelessWidget {
  final double? textSize;
  final String? text;
  const TextEmptyViewData({super.key, this.textSize, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextInAppWidget(
        text: text ?? LocaleKeys.empty,
        textSize: textSize ?? 15,
        textColor: AppColors.greyColor,
      ),
    );
  }
}
