import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_cubit.dart';
import 'package:web_admin_san/feature/internal_services/view_model/loading_dashboard/loading_dashboard_state.dart';

class FirstRowInDataInContainerRateService extends StatelessWidget {
  const FirstRowInDataInContainerRateService({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 50,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TextInAppWidget(
            text: LocaleKeys.internalServicesRating,
            textSize: 15,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          ),
          Row(
            spacing: 10,
            children: [
              Flexible(child: Image.asset(AppImageKeys.star11)),
              BlocBuilder<InternalOrdersCubit, InternalOrdersState>(
                buildWhen: (previous, current) =>
                    previous.averageRate != current.averageRate,
                builder: (context, state) {
                  return TextInAppWidget(
                    text: state.averageRate.toStringAsFixed(1),
                    textSize: 15,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.blackColor,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
