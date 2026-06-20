import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class CustomTabSelectRateService extends StatelessWidget {
  final String title;
  final Uint8List? imagePath;
  final String? imageAsset;
  final bool isSelect;
  const CustomTabSelectRateService({
    super.key,
    this.imagePath,
    required this.title,
    this.imageAsset,
    this.isSelect=true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelect?AppColors.orangeColor:AppColors.veryLightGreyColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        //border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imagePath != null
              ? Image.memory(
            imagePath!,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          )
              : imageAsset != null
              ? Image.asset(
            imageAsset!,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          )
              : const SizedBox(),
          const SizedBox(width: 10),
          TextInAppWidget(
            text: title,
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: isSelect?AppColors.whiteColor:AppColors.orangeColor,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
