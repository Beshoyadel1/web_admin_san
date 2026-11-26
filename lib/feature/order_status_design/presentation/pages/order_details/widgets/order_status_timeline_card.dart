import 'package:easy_localization/easy_localization.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/networking/api_link.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_details_model.dart';

enum OrderTimelineStepState { completed, active, pending, rejected }

class OrderTimelineItem {
  final String title;
  final String time;
  final OrderTimelineStepState state;
  final String? subtitle;

  const OrderTimelineItem({
    required this.title,
    required this.time,
    required this.state,
    this.subtitle,
  });
}

class OrderStatusTimelineCard extends StatelessWidget {
  final OrderDetailsModel? orderDetails;

  const OrderStatusTimelineCard({
    super.key,
    required this.orderDetails,
  });

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '--:--';
    return '${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeForStatus(int targetStatus) {
    final history = orderDetails?.statusHistory;
    if (history != null && history.isNotEmpty) {
      for (final item in history.reversed) {
        if (item.newstatus == targetStatus && item.date != null) {
          return _formatDateTime(item.date);
        }
      }
    }
    return '--:--';
  }

  List<OrderTimelineItem> _buildSteps(int currentStatus) {
    final creationTime = _formatDateTime(orderDetails?.date);
    final history = orderDetails?.statusHistory;

    // 1. Dynamic Timeline based on statusHistory
    if (history != null && history.isNotEmpty) {
      final List<OrderTimelineItem> steps = [];

      // Sort history defensively in chronological order (oldest to newest)
      final sortedHistory = List.of(history)
        ..sort((a, b) {
          final dateA = a.date ?? DateTime.fromMillisecondsSinceEpoch(0);
          final dateB = b.date ?? DateTime.fromMillisecondsSinceEpoch(0);
          final comp = dateA.compareTo(dateB);
          if (comp != 0) return comp;
          return (a.id ?? 0).compareTo(b.id ?? 0);
        });

      // Step 1: Order Created
      steps.add(
        OrderTimelineItem(
          title: LocaleKeys.orderCreatedTimeline.tr(),
          time: creationTime,
          state: OrderTimelineStepState.completed,
        ),
      );

      final seenStatuses = <int>{
        OrderStatus.newOrderForCompany,
        OrderStatus.newOrderForProvider,
      };

      for (int i = 0; i < sortedHistory.length; i++) {
        final item = sortedHistory[i];
        final newStatus = item.newstatus ?? 0;

        // Skip initial creation status because it's already shown at root
        if (newStatus == OrderStatus.newOrderForCompany ||
            newStatus == OrderStatus.newOrderForProvider) {
          continue;
        }

        // Avoid duplicate identical status transitions
        if (seenStatuses.contains(newStatus)) {
          continue;
        }

        final isLastHistoryItem = i == sortedHistory.length - 1;
        final isTerminalRejected = newStatus == OrderStatus.rejectedByCompany ||
            newStatus == OrderStatus.rejectedByProvider ||
            newStatus == OrderStatus.cancelledByUser;

        final stepState = isTerminalRejected
            ? OrderTimelineStepState.rejected
            : (isLastHistoryItem &&
                    currentStatus == newStatus &&
                    newStatus != OrderStatus.orderCompleted
                ? OrderTimelineStepState.active
                : OrderTimelineStepState.completed);

        final title = OrderStatusToString.toLocalized(newStatus);
        final time = _formatDateTime(item.date);
        final subtitle =
            item.changedbyname != null && item.changedbyname!.trim().isNotEmpty
                ? LocaleKeys.byUser.tr(args: [item.changedbyname!.trim()])
                : null;

        steps.add(
          OrderTimelineItem(
            title: title.isNotEmpty ? title : '#$newStatus',
            time: time,
            state: stepState,
            subtitle: subtitle,
          ),
        );
        seenStatuses.add(newStatus);
      }

      // Append upcoming pending steps if order is not completed/rejected
      final isTerminal = currentStatus == OrderStatus.rejectedByCompany ||
          currentStatus == OrderStatus.rejectedByProvider ||
          currentStatus == OrderStatus.cancelledByUser ||
          currentStatus == OrderStatus.orderCompleted;

      if (!isTerminal) {
        final standardProgression = [
          OrderStatus.waitingAppointment,
          OrderStatus.employeeInRoad,
          OrderStatus.workInProgress,
          OrderStatus.orderCompleted,
        ];

        for (final nextStatus in standardProgression) {
          if (!seenStatuses.contains(nextStatus) &&
              nextStatus > currentStatus) {
            steps.add(
              OrderTimelineItem(
                title: OrderStatusToString.toLocalized(nextStatus),
                time: '--:--',
                state: OrderTimelineStepState.pending,
              ),
            );
          }
        }
      }

      return steps;
    }

    // 2. Standard Fallback if statusHistory is empty
    return _buildStandardSteps(currentStatus, creationTime);
  }

  List<OrderTimelineItem> _buildStandardSteps(
      int currentStatus, String creationTime) {
    // Terminal rejection / cancellation states
    if (currentStatus == OrderStatus.rejectedByCompany) {
      return [
        OrderTimelineItem(
          title: LocaleKeys.orderCreatedTimeline.tr(),
          time: creationTime,
          state: OrderTimelineStepState.completed,
        ),
        OrderTimelineItem(
          title: LocaleKeys.rejectedByCompany.tr(),
          time: _getTimeForStatus(OrderStatus.rejectedByCompany),
          state: OrderTimelineStepState.rejected,
        ),
      ];
    }

    if (currentStatus == OrderStatus.rejectedByProvider) {
      return [
        OrderTimelineItem(
          title: LocaleKeys.orderCreatedTimeline.tr(),
          time: creationTime,
          state: OrderTimelineStepState.completed,
        ),
        OrderTimelineItem(
          title: LocaleKeys.rejectedByProvider.tr(),
          time: _getTimeForStatus(OrderStatus.rejectedByProvider),
          state: OrderTimelineStepState.rejected,
        ),
      ];
    }

    if (currentStatus == OrderStatus.cancelledByUser) {
      return [
        OrderTimelineItem(
          title: LocaleKeys.orderCreatedTimeline.tr(),
          time: creationTime,
          state: OrderTimelineStepState.completed,
        ),
        OrderTimelineItem(
          title: LocaleKeys.cancelledByCustomer.tr(),
          time: _getTimeForStatus(OrderStatus.cancelledByUser),
          state: OrderTimelineStepState.rejected,
        ),
      ];
    }

    // Lifecycle progression:
    // Only move beyond pending when status is actually reached
    final isAcceptedCompleted = currentStatus > OrderStatus.waitingAppointment;
    final isAcceptedActive = currentStatus == OrderStatus.waitingAppointment;

    final isOnTheWayCompleted = currentStatus > OrderStatus.employeeInRoad;
    final isOnTheWayActive = currentStatus == OrderStatus.employeeInRoad;

    final isInProgressCompleted = currentStatus > OrderStatus.workInProgress;
    final isInProgressActive = currentStatus == OrderStatus.workInProgress;

    final isCompleted = currentStatus == OrderStatus.orderCompleted;

    return [
      OrderTimelineItem(
        title: LocaleKeys.orderCreatedTimeline.tr(),
        time: creationTime,
        state: OrderTimelineStepState.completed,
      ),
      OrderTimelineItem(
        title: LocaleKeys.orderAcceptedAndAssigned.tr(),
        time: isAcceptedCompleted || isAcceptedActive
            ? _getTimeForStatus(OrderStatus.waitingAppointment)
            : '--:--',
        state: isAcceptedCompleted
            ? OrderTimelineStepState.completed
            : (isAcceptedActive
                ? OrderTimelineStepState.active
                : OrderTimelineStepState.pending),
      ),
      OrderTimelineItem(
        title: LocaleKeys.employeeOnTheWay.tr(),
        time: isOnTheWayCompleted || isOnTheWayActive
            ? _getTimeForStatus(OrderStatus.employeeInRoad)
            : '--:--',
        state: isOnTheWayCompleted
            ? OrderTimelineStepState.completed
            : (isOnTheWayActive
                ? OrderTimelineStepState.active
                : OrderTimelineStepState.pending),
      ),
      OrderTimelineItem(
        title: LocaleKeys.orderInProgressTimeline.tr(),
        time: isInProgressCompleted || isInProgressActive
            ? _getTimeForStatus(OrderStatus.workInProgress)
            : '--:--',
        state: isInProgressCompleted
            ? OrderTimelineStepState.completed
            : (isInProgressActive
                ? OrderTimelineStepState.active
                : OrderTimelineStepState.pending),
      ),
      OrderTimelineItem(
        title: LocaleKeys.orderCompletedTimeline.tr(),
        time: isCompleted
            ? _getTimeForStatus(OrderStatus.orderCompleted)
            : '--:--',
        state: isCompleted
            ? OrderTimelineStepState.completed
            : OrderTimelineStepState.pending,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final status = orderDetails?.effectiveStatus ?? orderDetails?.status ?? 0;
    final steps = _buildSteps(status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.veryLightGreyColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.timeline_rounded,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              TextInAppWidget(
                text: LocaleKeys.orderStages.tr(),
                textSize: 16,
                fontWeightIndex: FontSelectionData.boldFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Column(
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              final isLast = index == steps.length - 1;
              return OrderTimelineStepWidget(step: step, isLast: isLast);
            }),
          ),
        ],
      ),
    );
  }
}

class OrderTimelineStepWidget extends StatelessWidget {
  final OrderTimelineItem step;
  final bool isLast;

  const OrderTimelineStepWidget({
    super.key,
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Node and connector line
          Column(
            children: [
              OrderTimelineStepIcon(state: step.state),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: step.state == OrderTimelineStepState.completed
                        ? AppColors.orangeColor
                        : (step.state == OrderTimelineStepState.rejected
                            ? AppColors.redColor
                            : AppColors.veryLightGreyColor),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Step Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInAppWidget(
                          text: step.title,
                          textSize: 13,
                          textColor: step.state == OrderTimelineStepState.active
                              ? AppColors.orangeColor
                              : (step.state == OrderTimelineStepState.completed
                                  ? AppColors.darkColor
                                  : (step.state ==
                                          OrderTimelineStepState.rejected
                                      ? AppColors.redColor
                                      : AppColors.darkGreyColor)),
                          fontWeightIndex:
                              step.state == OrderTimelineStepState.active
                                  ? FontSelectionData.boldFontFamily
                                  : FontSelectionData.mediumFontFamily,
                          isEllipsisTextOverflow: true,
                        ),
                        if (step.subtitle != null &&
                            step.subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          TextInAppWidget(
                            text: step.subtitle!,
                            textSize: 11,
                            textColor: AppColors.darkGreyColor,
                            fontWeightIndex:
                                FontSelectionData.regularFontFamily,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextInAppWidget(
                    text: step.time,
                    textSize: 11,
                    textColor: AppColors.darkGreyColor,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTimelineStepIcon extends StatelessWidget {
  final OrderTimelineStepState state;

  const OrderTimelineStepIcon({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case OrderTimelineStepState.completed:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.orangeColor,
          ),
          child: const Icon(
            Icons.check,
            size: 14,
            color: AppColors.whiteColor,
          ),
        );
      case OrderTimelineStepState.active:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.orangeColor, width: 2),
            color: AppColors.whiteColor,
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orangeColor,
              ),
            ),
          ),
        );
      case OrderTimelineStepState.pending:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.veryLightGreyColor,
          ),
        );
      case OrderTimelineStepState.rejected:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.redColor,
          ),
          child: const Icon(
            Icons.close,
            size: 14,
            color: AppColors.whiteColor,
          ),
        );
    }
  }
}
