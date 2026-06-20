import 'package:flutter/cupertino.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class ImageWithDateTitleWidget extends StatelessWidget {
  final String imagePath, date, text;

  const ImageWithDateTitleWidget({
    super.key,
    required this.imagePath,
    required this.date,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        spacing: 5,
        children: [
          Flexible(child: Image.asset(imagePath)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInAppWidget(
                  text: date,
                  textSize: 11,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.blackColor,
                ),
                // TextInAppWidget(
                //   text: text,
                //   textSize: 13,
                //   fontWeightIndex: FontSelectionData.mediumFontFamily,
                //   textColor: AppColors.blackColor,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
