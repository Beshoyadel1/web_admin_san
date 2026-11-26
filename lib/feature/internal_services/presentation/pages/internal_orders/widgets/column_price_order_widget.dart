import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/row_text_icon_orange.dart';
import '../../../../../../../core/helpers/constants/assets.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class ColumnPriceOrderWidget extends StatelessWidget {
  final String price;
  final String? title;

  const ColumnPriceOrderWidget({super.key, required this.price, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        TextInAppWidget(
          text: title ?? LocaleKeys.servicePrice,
          textSize: 11,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.greyColor,
        ),
        RowTextIconOrange(text: price, imagePath: AppImageKeys.coin),
      ],
    );
  }
}
