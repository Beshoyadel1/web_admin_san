import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/pages_widgets/text_form_field_widget.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'package:web_admin_san/core/theming/fonts.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';

class DesignNotesOrder extends StatelessWidget {
  const DesignNotesOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {},
      isSelected: true,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.orangeColor.withOpacity(0.4)),
      typeWidget:Column(
        spacing: 10,
        children: [
          const TextInAppWidget(
            text:AppLanguageKeys.notes,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
          TextFormFieldWidget(
            textFormController:TextEditingController(),
            maxLines: 5,
            fillColor: WidgetStateColor.transparent,
            borderColor: AppColors.greyColor.withOpacity(0.5),
          )
        ],
      ),
    );
  }
}
