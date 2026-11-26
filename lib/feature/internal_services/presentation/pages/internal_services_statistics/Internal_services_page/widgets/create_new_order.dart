import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/internal_services/data/model/new_order_steps_model/new_order_steps_model.dart';
import 'package:web_admin_san/feature/internal_services/view_model/new_orders_cubit/new_orders_cubit.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../core/helpers/themes/text_styles.dart';
import 'details_order.dart';
import 'payment_widget.dart';

class CreateNewOrder extends StatelessWidget {
  const CreateNewOrder(
      {super.key,
      this.textButton,
      this.isProcessingRequest,
      this.isWaitingPayment});

  final String? textButton;
  final bool? isProcessingRequest;
  final bool? isWaitingPayment;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsOrder(isProcessingRequest: isProcessingRequest),
        isWaitingPayment == true
            ? const PaymentWidget()
            : CustomContainer(
                isSelected: false,
                onTap: () {
                  final cubit = context.read<NewOrdersCubit>();
                  if (cubit.selectedIndex < steps.length - 1) {
                    cubit.selectTab(cubit.selectedIndex + 1);
                  }
                },
                containerHeight: 40,
                containerWidth: 140,
                border: const Border(),
                borderRadius: BorderRadius.circular(20),
                containerColor: AppColors.orangeColor,
                typeWidget: Center(
                  child: TextInAppWidget(
                    text: textButton ?? LocaleKeys.executeOrderKey,
                    textSize: 14,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              )
      ],
    );
  }
}
