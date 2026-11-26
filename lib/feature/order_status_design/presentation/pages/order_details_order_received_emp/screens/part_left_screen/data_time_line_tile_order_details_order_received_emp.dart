import 'package:flutter/cupertino.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/time_line_tile_widget.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';

class DataTimeLineTileOrderDetailsOrderReceivedEmp extends StatelessWidget {
  const DataTimeLineTileOrderDetailsOrderReceivedEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
          // children: [
          //   TimeLineTileWidget(
          //     isFirst: true,
          //     isIcon: true,
          //     title: LocaleKeys.createNewOrderKey,
          //   ),
          //   TimeLineTileWidget(
          //     isIcon: true,
          //     title: LocaleKeys.orderInProgress,
          //   ),
          //   TimeLineTileWidget(
          //     isIcon: true,
          //     title: LocaleKeys.waitingForInvoicePayment,
          //   ),
          //   TimeLineTileWidget(
          //     isLast: true,
          //     isIcon: true,
          //     title: LocaleKeys.orderArrived,
          //   ),
          // ],
          ),
    );
  }
}
