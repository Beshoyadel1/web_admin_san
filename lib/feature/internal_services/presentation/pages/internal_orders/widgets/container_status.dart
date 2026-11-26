import 'package:flutter/material.dart';
import '../../../../../../../core/networking/api_link.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';

class ContainerStatus extends StatelessWidget {
  final int? status;
  final double? textSize;

  const ContainerStatus({
    super.key,
    this.status,
    this.textSize,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.newOrderForCompany:
        return LocaleKeys.newOrderForCompany;

      case OrderStatus.rejectedByCompany:
        return LocaleKeys.rejectedByCompany;

      case OrderStatus.newOrderForProvider:
        return LocaleKeys.newOrderForProvider;

      case OrderStatus.waitingAppointment:
        return LocaleKeys.waitingAppointment;

      case OrderStatus.employeeInRoad:
        return LocaleKeys.employeeInRound;

      case OrderStatus.workInProgress:
        return LocaleKeys.workInProgress;

      case OrderStatus.orderCompleted:
        return LocaleKeys.orderCompleted;

      case OrderStatus.rejectedByProvider:
        return LocaleKeys.rejectedByProvider;

      case OrderStatus.cancelledByUser:
        return LocaleKeys.cancelledByUser;

      default:
        return LocaleKeys.unknownType;
    }
  }

  bool get isNewOrder =>
      status == OrderStatus.newOrderForCompany ||
      status == OrderStatus.newOrderForProvider;

  bool get isReject =>
      status == OrderStatus.rejectedByCompany ||
      status == OrderStatus.rejectedByProvider ||
      status == OrderStatus.cancelledByUser;

  bool get isWaitingForApproval => status == OrderStatus.waitingAppointment;

  bool get isOnTheWay => status == OrderStatus.employeeInRoad;

  bool get isAccept => status == OrderStatus.orderCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isNewOrder
            ? AppColors.blackColor25
            : isReject
                ? AppColors.partPinkMixColor.withOpacity(0.1)
                : isAccept
                    ? AppColors.partGreenMixColor.withOpacity(0.1)
                    : isWaitingForApproval
                        ? AppColors.yelloContainerLoadingColor.withOpacity(0.2)
                        : isOnTheWay
                            ? AppColors.lightGreenColor
                            : AppColors.pinkColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(
            isNewOrder
                ? Icons.file_open_outlined
                : isReject
                    ? Icons.close
                    : isAccept
                        ? Icons.done
                        : isWaitingForApproval
                            ? Icons.autorenew
                            : isOnTheWay
                                ? Icons.airport_shuttle_outlined
                                : Icons.settings,
            size: 15,
            color: isNewOrder
                ? AppColors.blackColor44
                : isReject
                    ? AppColors.redColor
                    : isAccept
                        ? AppColors.greenColor
                        : isWaitingForApproval
                            ? AppColors.yelloIconLoadingColor
                            : isOnTheWay
                                ? AppColors.blueColor
                                : AppColors.orangeColor,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextInAppWidget(
              text: statusText,
              textSize: textSize ?? 9,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: isNewOrder
                  ? AppColors.blackColor44
                  : isReject
                      ? AppColors.redColor
                      : isAccept
                          ? AppColors.greenColor
                          : isWaitingForApproval
                              ? AppColors.yelloTextLoadingColor
                              : isOnTheWay
                                  ? AppColors.blueColor
                                  : AppColors.orangeColor,
            ),
          ),
        ],
      ),
    );
  }
}
