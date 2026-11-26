import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/feature/order_status_design/presentation/widgets/time_line_tile_widget.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../core/helpers/colors/app_colors.dart';

class DataTimeLineTileOrderDetailsNewOrderEmp extends StatelessWidget {
  const DataTimeLineTileOrderDetailsNewOrderEmp({super.key});

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
          //
          //   ),
          //   TimeLineTileWidget(
          //     text: '2',
          //     title: LocaleKeys.orderInProgress,
          //     subTitle: '',
          //     colorAfterLine: AppColors.greyColor,
          //   ),
          //   TimeLineTileWidget(
          //     text: '3',
          //     title: LocaleKeys.waitingForInvoicePayment,
          //     subTitle: '',
          //     colorAfterLine: AppColors.greyColor,
          //     colorBeforeLine: AppColors.greyColor,
          //     colorBorder: AppColors.greyColor,
          //     textColor: AppColors.greyColor,
          //     textColorTitle: AppColors.greyColor,
          //   ),
          //   TimeLineTileWidget(
          //     isLast: true,
          //     text: '4',
          //     textColor: AppColors.greyColor,
          //     title: LocaleKeys.orderArrived,
          //     textColorTitle: AppColors.greyColor,
          //     subTitle: '',
          //     colorBeforeLine: AppColors.greyColor,
          //     colorBorder: AppColors.greyColor,
          //   ),
          // ],
          ),
    );
  }
}
