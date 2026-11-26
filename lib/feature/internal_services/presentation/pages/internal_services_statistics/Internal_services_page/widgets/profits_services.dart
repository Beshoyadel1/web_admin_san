import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/cars_haraj_page/presentation/ui/cars_haraj_statistics_page/screens/aspect_ratio_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class ProfitsServices extends StatelessWidget {
  const ProfitsServices({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        containerWidth: 500,
        borderRadius: BorderRadius.circular(12),
        isSelected: false,
        onTap: () {},
        typeWidget: const Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextInAppWidget(
                    text: LocaleKeys.internalServicesProfitKey,
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                  ),
                  // TextInAppWidget(
                  //   text: LocaleKeys.priceKey,
                  //   textSize: 16,
                  //   fontWeightIndex: FontSelectionData.regularFontFamily,
                  //   textColor: AppColors.orangeColor,
                  // ),
                ],
              ),
              //  SelectDateWidget(),
              AspectRatioWidget(),
              SizedBox(
                height: 10,
              ),
            ]));
  }
}
