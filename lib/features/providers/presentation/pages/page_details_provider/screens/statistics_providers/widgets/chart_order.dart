import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:web_admin_san/core/theming/text_styles.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/statistics_providers_cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_cubit.dart';
import '../../../../../../../../core/theming/fonts.dart';
import 'custom_line_chart.dart';

class ChartOrder extends StatelessWidget {
  final int providerId;
  const ChartOrder({super.key,required this.providerId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= 1320;
    return CustomContainer(
        containerWidth: isMobile?double.infinity:520,
        containerHeight: 504,
        isSelected: false,
        onTap: () {},
        typeWidget:  Column(
          spacing: 60,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextInAppWidget(
                    text: AppLanguageKeys.ordersKey,
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                  ),
                 // SizedBox(width: 300, child: SelectDateWidget()),
                ],
              ),
            ),
            BlocProvider(
              create: (_) =>
              GetProviderOrdersSalesCubit()
                ..getProviderOrdersSales(
                  providerId:providerId
                ),
              child: const CustomLineChart(),
            )
          ],
        ));
  }
}
