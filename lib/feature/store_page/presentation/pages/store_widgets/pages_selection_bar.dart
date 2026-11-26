import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_states.dart';
import 'package:web_admin_san/core/di/sl.dart';
import '../../../../../core/helpers/constants/assets.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'column_of_pages_widget.dart';

class PagesSelectionBar extends StatefulWidget {
  const PagesSelectionBar({super.key});

  @override
  State<PagesSelectionBar> createState() => _PagesSelectionBarState();
}

class _PagesSelectionBarState extends State<PagesSelectionBar> {
  final AppCubit _appCubit = getIt<AppCubit>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    return Container(
      width: 256,
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadiusDirectional.only(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(
            child: Image.asset(AppImageKeys.logoContainer, height: 80),
          ),
          const SizedBox(
            height: 60,
          ),
          Expanded(
            child: BlocBuilder<AppCubit, AppStates>(
              buildWhen: (previous, current) {
                return current is ChangeSelectedPageIndexState ||
                    current is ChangeAllAppLanguageState;
              },
              builder: (BuildContext context, AppStates state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final page in appPages) ...[
                          ColumnOfPagesWidget(
                            pageNode: page,
                            appCubit: _appCubit,
                            isMobile: isMobile,
                          ),
                          const Divider(
                            thickness: 1,
                            color: AppColors.orangeColor,
                          )
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
