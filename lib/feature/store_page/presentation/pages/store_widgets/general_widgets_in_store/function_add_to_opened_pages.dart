import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/helpers/models/pages_model.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import '../dialog_for_back.dart';
import '../page_name_function.dart';

Future<void> addToOpenedPages(
    {required BuildContext context, required AppCubit appCubit}) async {
  final bool shouldPop = await showBackDialog(context: context) ?? false;
  if (shouldPop) {
    PageNodeWithIDModel pageNodeWithID = PageNodeWithIDModel(
      name: findPageByNumber(appCubit.selectedPageIndex, appPages)?.name ?? '',
      number: appCubit.selectedPageIndex,
      page: findPageByNumber(appCubit.selectedPageIndex, appPages)?.page,
      id: ((appCubit.openedPages
                  .where(
                      (element) => element.number == appCubit.selectedPageIndex)
                  .lastOrNull
                  ?.id) ??
              0) +
          1,
    );

    appCubit.openedPages.add(pageNodeWithID);
    appCubit.changeOpenedPages();

    final key = '${pageNodeWithID.number}${pageNodeWithID.id}';

    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setStringList(
          key, appCubit.data.map((e) => e.toString()).toList());
      appCubit.data.clear();
    });
  }
}
