import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/feature/statistics_page/presentation/pages/statistics_page/screens/part_two_screen_first_screen_order_services_statistics/container_current_year_sales/data_in_container_current_year_sales.dart';

import '../../../../../../../../../../core/helpers/colors/app_colors.dart';

class ContainerCurrentYearSales extends StatelessWidget {
  const ContainerCurrentYearSales({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(20),
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
      child: const DataInContainerCurrentYearSales(),
    );
  }
}
