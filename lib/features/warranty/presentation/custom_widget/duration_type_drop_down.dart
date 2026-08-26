import 'package:flutter/material.dart';
import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/text_styles.dart';

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

    final int? dropdownValue =
    isKnownType ? selectedDurationTypeId : null;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: TextInAppWidget(
              text: AppLanguageKeys.durationType,
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
                  text: AppLanguageKeys.selectDurationType,
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