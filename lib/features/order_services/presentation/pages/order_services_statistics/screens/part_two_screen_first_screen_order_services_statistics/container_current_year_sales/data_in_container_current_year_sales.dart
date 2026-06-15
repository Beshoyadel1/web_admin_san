import 'package:flutter/cupertino.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_current_year_sales/fast_line_with_fill_container_current_year_sales.dart';
import 'package:web_admin_san/features/order_services/presentation/pages/order_services_statistics/screens/part_two_screen_first_screen_order_services_statistics/container_current_year_sales/first_row_in_data_in_container_current_year_sales.dart';

class DataInContainerCurrentYearSales extends StatelessWidget {
  const DataInContainerCurrentYearSales({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        const FirstRowInDataInContainerCurrentYearSales(),
        FastLineWithFillContainerCurrentYearSales(),
      ],
    );
  }
}
