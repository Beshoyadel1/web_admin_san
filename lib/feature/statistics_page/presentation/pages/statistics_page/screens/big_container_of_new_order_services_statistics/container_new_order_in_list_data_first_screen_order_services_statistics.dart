import 'package:flutter/cupertino.dart';

import '../../../../../../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/big_container_of_new_order_services_statistics/data_container_in_list_data_first_screen_order_services_statistics.dart';

class ContainerNewOrderInListDataFirstScreenStatisticsPage
    extends StatelessWidget {
  final void Function()? onTap;
  final int serviceId;

  const ContainerNewOrderInListDataFirstScreenStatisticsPage(
      {super.key, this.onTap, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DataContainerInListDataFirstScreenStatisticsPage(
        onTap: onTap,
        serviceId: serviceId,
      ),
    );
  }
}
