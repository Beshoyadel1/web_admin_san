import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/rates_page/presentation/widgets/custom_tab_select_rate_service.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../widgets/container_with_image_container_and_two_text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstRowWithTwoContainerImageAndTwoText extends StatelessWidget {
  const FirstRowWithTwoContainerImageAndTwoText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';

            const minItemWidth = 220.0;

            int itemsPerRow = (constraints.maxWidth / minItemWidth).floor();

            if (itemsPerRow == 0) itemsPerRow = 1;

            final itemWidth = (constraints.maxWidth / itemsPerRow) - 10;

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: state.services.map((service) {
                final title = isArabic
                    ? (service.serviceName ?? '')
                    : (service.serviceLatinName ?? '');

                return SizedBox(
                  width: itemWidth,
                  child: CustomTabSelectRateService(
                    imagePath: service.image,
                    title: title,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
