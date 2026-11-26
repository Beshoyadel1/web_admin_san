import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/pages/order_details/order_details.dart';
import 'package:web_admin_san/feature/internal_services/data/model/get_provider_orders_model/order_model.dart';
import 'package:web_admin_san/feature/internal_services/view_model/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/navigate_to_page_widget.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import '../../../../../../core/networking/api_link.dart';

class ContainerDetailsWidget extends StatelessWidget {
  final String? title;
  final int status, serviceId;
  final Color? backGroundColor, textColor, borderColor;
  final OrderModel order;

  const ContainerDetailsWidget(
      {super.key,
      required this.status,
      this.title,
      this.textColor,
      this.borderColor,
      this.backGroundColor,
      required this.order,
      required this.serviceId});

  void _handleNavigation(BuildContext context) async {
    Widget page;

    switch (status) {
      case OrderStatus.newOrderForProvider:
      case OrderStatus.newOrderForCompany:
      case OrderStatus.orderCompleted:
      case OrderStatus.employeeInRoad:
      case OrderStatus.workInProgress:
      case OrderStatus.rejectedByProvider:
      case OrderStatus.rejectedByCompany:
      case OrderStatus.cancelledByUser:
      case OrderStatus.waitingAppointment:
        page = OrderDetails(order: order);
        break;

      default:
        return;
    }

    final result = await Navigator.push(
      context,
      NavigateToPageWidget(page),
    );

    if (result == true && context.mounted) {
      try {
        context.read<GetProviderInternalOrderCubit>().loadInternalOrders(
              serviceId: serviceId,
            );
      } catch (_) {}
    }
  }

  bool get _isEnabled {
    return status == OrderStatus.newOrderForProvider ||
        status == OrderStatus.newOrderForCompany ||
        status == OrderStatus.orderCompleted ||
        status == OrderStatus.employeeInRoad ||
        status == OrderStatus.rejectedByProvider ||
        status == OrderStatus.rejectedByCompany ||
        status == OrderStatus.cancelledByUser ||
        status == OrderStatus.waitingAppointment ||
        status == OrderStatus.workInProgress;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isEnabled ? () => _handleNavigation(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: (backGroundColor ?? AppColors.whiteColor),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: _isEnabled
                ? (borderColor ?? AppColors.orangeColor)
                : AppColors.greyColor,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: TextInAppWidget(
            text: title ?? LocaleKeys.details,
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: _isEnabled
                ? (textColor ?? AppColors.orangeColor)
                : AppColors.greyColor,
          ),
        ),
      ),
    );
  }
}
