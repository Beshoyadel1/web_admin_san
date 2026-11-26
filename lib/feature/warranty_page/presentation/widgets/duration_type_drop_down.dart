import 'package:flutter/material.dart';
import '../../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../core/helpers/themes/text_styles.dart';

class DurationTypeDropdown extends StatelessWidget {
  final int? selectedDurationTypeId;
  final ValueChanged<int?> onChanged;
  final double width;

  const DurationTypeDropdown({
    super.key,
    required this.selectedDurationTypeId,
    required this.onChanged,
    this.width = 250,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKnownType = DurationType.all.any(
      (duration) => duration.id == selectedDurationTypeId,
    );

    final int? dropdownValue = isKnownType ? selectedDurationTypeId : null;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: LocaleKeys.durationType,
              textSize: 14,
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.darkGreyColor,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: dropdownValue,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                ),
                hint: const TextInAppWidget(
                  text: LocaleKeys.selectDurationType,
                  textSize: 14,
                ),
                items: DurationType.all.map(
                  (duration) {
                    return DropdownMenuItem<int>(
                      value: duration.id,
                      child: TextInAppWidget(
                        text: duration.name,
                        textSize: 14,
                      ),
                    );
                  },
                ).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
