import '../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_cubit.dart';
import 'package:web_admin_san/feature/layout/view_model/layout_cubit/app_states.dart';
import 'package:web_admin_san/core/di/sl.dart';
import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_page.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_widgets/session_expired_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _selectInitialPage();
    _initializePages();
  }

  void _selectInitialPage() {
    if (appPages.isEmpty) return;

    final dashboardPages = appPages.where(
      (e) => e.number == PagesOfAllApp.dashboardPageNumber,
    );

    final selectedPage =
        dashboardPages.isNotEmpty ? dashboardPages.first : appPages.first;

    if (_appCubit.selectedPageIndex <= 0) {
      _appCubit.selectedPageFromOpenedPagesIndex = selectedPage.number;
      _appCubit.selectedPageIndex = selectedPage.number;
    }
  }

  Future<void> _initializePages() async {
    if (appPages.isEmpty) {
      await getPages();
      if (!mounted) return;
      _selectInitialPage();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width <= ValuesOfAllApp.mobileWidth;

    if (appPages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: TextInAppWidget(text: LocaleKeys.noPagesAvailableKey),
        ),
      );
    }

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current is AuthSessionExpired,
      listener: (context, state) {
        if (state is AuthSessionExpired) {
          SessionExpiredDialog.show(
            context,
            onConfirm: () {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                NavigateToPageWidget(
                  const LoginPage(isSessionExpired: false),
                ),
                (route) => false,
              );
            },
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) return;

          final shouldPop = await showBackDialog(context: context) ?? false;

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
      ),
    );
  }
}
