import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../../core/widgets/text_form_field_widget.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class DesignNotesOrder extends StatelessWidget {
  final String note;
  const DesignNotesOrder({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {},
      isSelected: true,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.orangeColor.withValues(alpha: 0.4)),
      typeWidget: Column(
        spacing: 10,
        children: [
          const TextInAppWidget(
            text: LocaleKeys.notes,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
          TextFormFieldWidget(
            textFormController: TextEditingController(text: note),
            maxLines: 5,
            fillColor: WidgetStateColor.transparent,
            borderColor: AppColors.greyColor.withValues(alpha: 0.5),
            readOnly: true,
          )
        ],
      ),
    );
  }
}
