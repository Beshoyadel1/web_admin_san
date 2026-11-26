import 'package:flutter/material.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import 'harage_container_status.dart';

class TextWithHarageContainerStatus extends StatelessWidget {
  final String? text;
  final double? textSizeContainer;
  final double? textSize;
  final int? status;

  const TextWithHarageContainerStatus({
    super.key,
    this.status,
    this.text,
    this.textSizeContainer,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: text ?? LocaleKeys.requestStatus,
          textSize: textSize ?? 11,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.greyColor,
        ),
        HarageContainerStatus(
          status: status,
          textSize: textSizeContainer,
        ),
      ],
    );
  }
}
