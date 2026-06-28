import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/features/company/presentation/custom_widget/text_expended_widget.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_last_year_sales/fast_line_with_fill_container_last_year_sales.dart';

class DataInContainerPetrolConsumptionCompany extends StatelessWidget {
  const DataInContainerPetrolConsumptionCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        const TextExpendedWidget(
          text: AppLanguageKeys.fuelConsumptionStatistics,
        ),
        //FastLineWithFillContainerLastYearSales(),
      ],
    );
  }
}
