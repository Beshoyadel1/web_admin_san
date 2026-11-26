import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/widgets/detail_section_card.dart';
import 'package:web_admin_san/feature/providers_page/presentation/pages/page_details_provider/screens/working_hours_providers/screens/work_time_shift_card.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/work_time_cubit/work_time_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/work_time_cubit/work_time_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class WorkingHoursProviders extends StatelessWidget {
  final int providerID;
  const WorkingHoursProviders({super.key, required this.providerID});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.orangeColor,
      onRefresh: () async {
        await context.read<UpdateWorkTimeCubit>().getWorkTimes();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: BlocBuilder<UpdateWorkTimeCubit, WorkTimeState>(
          builder: (context, state) {
            final cubit = context.read<UpdateWorkTimeCubit>();

            if (state is WorkTimeLoading && cubit.workTimes.isEmpty) {
              return const SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orangeColor,
                  ),
                ),
              );
            }

            if (state is WorkTimeError && cubit.workTimes.isEmpty) {
              return SizedBox(
                height: 400,
                child: Center(
                  child: WorkTimesErrorWidget(
                    message: state.message,
                    onRetry: () {
                      cubit.getWorkTimes();
                    },
                  ),
                ),
              );
            }

            final workTimes = cubit.workTimes;

            return DetailSectionCard(
              title: LocaleKeys.workingHours.tr(),
              icon: Icons.access_time_filled_rounded,
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.orangeColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  "${workTimes.length} ${LocaleKeys.workingHours.tr()}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orangeColor,
                  ),
                ),
              ),
              child: workTimes.isEmpty
                  ? const WorkTimesEmptyWidget()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth >= 900;
                        final cardWidth = isDesktop
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth;

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: List.generate(workTimes.length, (index) {
                            return SizedBox(
                              width: cardWidth,
                              child: WorkTimeShiftCard(
                                shift: workTimes[index],
                                shiftIndex: index + 1,
                              ),
                            );
                          }),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}

class WorkTimesEmptyWidget extends StatelessWidget {
  const WorkTimesEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightOrangeColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 40,
                color: AppColors.orangeColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.allWorkingHours.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              LocaleKeys.notFound.tr(),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.darkGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkTimesErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const WorkTimesErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error_outline_rounded,
          size: 48,
          color: AppColors.redColor,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orangeColor,
            foregroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(LocaleKeys.retry.tr()),
        ),
      ],
    );
  }
}
