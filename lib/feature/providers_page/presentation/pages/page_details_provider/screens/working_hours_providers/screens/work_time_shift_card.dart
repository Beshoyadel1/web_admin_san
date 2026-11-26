import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/providers_page/data/model/facility_provider_model/upload_provider_work_times_model/work_time_model.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class WorkTimeShiftCard extends StatelessWidget {
  final WorkTimeModel shift;
  final int shiftIndex;

  const WorkTimeShiftCard({
    super.key,
    required this.shift,
    required this.shiftIndex,
  });

  static const List<String> daysKeys = [
    LocaleKeys.saturdayKey,
    LocaleKeys.sundayKey,
    LocaleKeys.mondayKey,
    LocaleKeys.tuesdayKey,
    LocaleKeys.wednesdayKey,
    LocaleKeys.thursdayKey,
    LocaleKeys.fridayKey,
  ];

  String _formatTime(String time, BuildContext context) {
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat.jm(locale).format(parsedTime);
    } catch (_) {
      return time;
    }
  }

  bool _isDayActive(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return shift.sat == true;
      case 1:
        return shift.sun == true;
      case 2:
        return shift.mon == true;
      case 3:
        return shift.tue == true;
      case 4:
        return shift.wed == true;
      case 5:
        return shift.thr == true;
      case 6:
        return shift.fri == true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final from = _formatTime(shift.fromTime ?? '', context);
    final to = _formatTime(shift.toTime ?? '', context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.access_time_filled_rounded,
                  size: 20,
                  color: AppColors.orangeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "$from - $to",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkColor,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.orangeColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  "#$shiftIndex",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orangeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.veryLightGreyColor,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 15,
                color: AppColors.darkGreyColor,
              ),
              const SizedBox(width: 6),
              Text(
                LocaleKeys.selectWorkDaysKey.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(daysKeys.length, (index) {
              final isDayActive = _isDayActive(index);
              final dayLabel = daysKeys[index].tr();

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDayActive
                      ? AppColors.orangeColor.withValues(alpha: 0.12)
                      : AppColors.veryLightGreyColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDayActive
                        ? AppColors.orangeColor
                        : AppColors.lightGreyColor,
                    width: isDayActive ? 1.2 : 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDayActive) ...[
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: AppColors.orangeColor,
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      dayLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isDayActive ? FontWeight.bold : FontWeight.normal,
                        color: isDayActive
                            ? AppColors.orangeColor
                            : AppColors.darkGreyColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
