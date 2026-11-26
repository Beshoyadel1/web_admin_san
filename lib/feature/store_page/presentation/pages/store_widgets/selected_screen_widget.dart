import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_states.dart';
import 'package:web_admin_san/core/di/sl.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'page_name_function.dart';

class SelectedScreenWidget extends StatefulWidget {
  const SelectedScreenWidget({super.key});

  @override
  State<SelectedScreenWidget> createState() => _SelectedScreenWidgetState();
}

class _SelectedScreenWidgetState extends State<SelectedScreenWidget> {
  final AppCubit _appCubit = getIt<AppCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      buildWhen: (previous, current) {
        return current is ChangeSelectedPageIndexState;
      },
      builder: (BuildContext context, AppStates state) {
        return Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.all(5),
            color: AppColors.greyColor.withValues(alpha: 0.1),
            child: context.read<AppCubit>().selectedPageFromOpenedPagesIndex >=
                        0 &&
                    context.read<AppCubit>().openedPages.isNotEmpty
                ? context
                    .read<AppCubit>()
                    .openedPages
                    .where((element) =>
                        element.id ==
                        context
                            .read<AppCubit>()
                            .selectedPageFromOpenedPagesIndex)
                    .first
                    .page
                : findPageByNumber(_appCubit.selectedPageIndex, appPages)?.page,
          ),
        );
      },
    );
  }
}
