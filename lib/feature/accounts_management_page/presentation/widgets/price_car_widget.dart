import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/row_number_coin_widget.dart';
import '../../../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class PriceCarWidget extends StatelessWidget {
  final String? price, text;
  final double? spacing;
  const PriceCarWidget({super.key, this.price, this.text, this.spacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing ?? 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: text ?? LocaleKeys.carPrice,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.greyColor,
        ),
        RowNumberCoinWidget(
          numberText: price ?? '250',
          sizeText: 15,
          imageSrc: AppImageKeys.coin,
        )
      ],
    );
  }
}
