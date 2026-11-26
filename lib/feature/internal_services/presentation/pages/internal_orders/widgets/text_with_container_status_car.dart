import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/container_status_car.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class TextWithContainerStatusCar extends StatelessWidget {
  final String? text;
  final double? textSizeContainer, textSize;
  final bool? isNew;
  final bool? isSold;

  const TextWithContainerStatusCar({
    super.key,
    this.isNew,
    this.isSold,
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
        ContainerStatusCar(
          isNew: isNew,
          isSold: isSold,
          textSize: textSizeContainer,
        )
      ],
    );
  }
}
