import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/general_models/pages_model.dart';
import '../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../core/cubit/app_cubit/app_states.dart';
import '../../../../core/setup_git_it.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/utilies/map_of_all_app.dart';
import 'store_widgets/app_bar_for_page.dart';
import 'store_widgets/dialog_for_back.dart';
import 'store_widgets/pages_selection_bar.dart';
import 'store_widgets/selected_screen_widget.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyDrawer =
      GlobalKey<ScaffoldState>();

  final AppCubit _appCubit = getIt<AppCubit>();

  bool _isLoadingPages = true;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  Future<void> _initializePages() async {
    await getPages();

    if (!mounted) return;

    if (appPages.isEmpty) {
      setState(() {
        _isLoadingPages = false;
      });
      return;
    }

// Try to open Dashboard if user has permission.
// Otherwise open the first allowed page.
    final dashboardPages = appPages.where(
      (e) => e.number == PagesOfAllApp.dashboardPageNumber,
    );

    final selectedPage =
        dashboardPages.isNotEmpty ? dashboardPages.first : appPages.first;

    _appCubit.selectedPageFromOpenedPagesIndex = selectedPage.number;

    _appCubit.selectedPageIndex = selectedPage.number;

    if (mounted) {
      setState(() {
        _isLoadingPages = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile =
        width <= ValuesOfAllApp.mobileWidth;

    if (_isLoadingPages) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (appPages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No pages available'),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final shouldPop =
            await showBackDialog(context: context) ?? false;

        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        key: _scaffoldKeyDrawer,
        backgroundColor: AppColors.whiteGreyColor,

        drawer: isMobile
            ? const Drawer(
          width: 256,
          child: PagesSelectionBar(),
        )
            : null,

        body: Row(
          children: [
            if (!isMobile)
              BlocBuilder<AppCubit, AppStates>(
                bloc: _appCubit,
                buildWhen: (previous, current) {
                  return current is HideMenuState;
                },
                builder: (context, state) {
                  if (!_appCubit.isMenuOpen) {
                    return const SizedBox.shrink();
                  }

                  return const PagesSelectionBar();
                },
              ),

            Expanded(
              child: Column(
                children: [
                  AppBarForPage(
                    scaffoldKey: _scaffoldKeyDrawer,
                  ),

                  const SelectedScreenWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

