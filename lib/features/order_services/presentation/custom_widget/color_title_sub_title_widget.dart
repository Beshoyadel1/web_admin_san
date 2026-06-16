import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class ColorTitleSubTitleWidget extends StatelessWidget {
  final Color? backgroundColor;
  final String? title,subTitle;
  const ColorTitleSubTitleWidget({super.key,this.backgroundColor,this.subTitle,this.title});

  @override
  Widget build(BuildContext context) {
    return  Row(
      spacing: 10,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor:backgroundColor?? Colors.blue,
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            TextInAppWidget(
              text:title?? 'سيارات المستخدمين',
              textSize: 15,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.blackColor,
            ),
            TextInAppWidget(
              text: subTitle??'300 سيارة',
              textSize: 12,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.greyColor,
            ),
          ],
        ))
      ],
    );
  }
}
