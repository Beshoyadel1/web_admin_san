import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/layout/model/map_of_all_app.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/store_page/presentation/pages/store_page.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/facility_account_check.dart';
import '../login_page/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.isAuth});

  final bool? isAuth;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    _navigateToNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    // 1. Preload appPages in the background so StorePage is instant
    if (appPages.isEmpty) {
      unawaited(getPages());
    }

    // 2. Minimum 3s display matching company project
    final delayFuture = Future.delayed(const Duration(seconds: 3));

    // Standalone mode if isAuth is directly provided
    if (widget.isAuth != null) {
      await delayFuture;
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        NavigateToPageWidget(
          widget.isAuth! ? const StorePage() : const LoginPage(),
        ),
      );
      return;
    }

    // Dynamic mode: wait for AuthCubit to finish resolving initial/loading state
    final authCubit = context.read<AuthCubit>();
    if (authCubit.state is AuthInitial || authCubit.state is AuthLoading) {
      await authCubit.stream.firstWhere(
        (s) => s is! AuthInitial && s is! AuthLoading,
      );
    }

    await delayFuture;
    if (!mounted) return;

    // Ensure pages are populated before transitioning to StorePage
    if (authCubit.state is AuthAuthenticated && appPages.isEmpty) {
      await getPages();
    }

    if (!mounted) return;

    final currentState = authCubit.state;
    final Widget targetPage;
    if (currentState is AuthAuthenticated) {
      targetPage = const StorePage();
    } else if (currentState is AuthIncompleteProfile ||
        currentState is AuthUpdateLoading ||
        currentState is AuthUpdateSuccess ||
        currentState is AuthUpdateError) {
      targetPage = const FacilityAccountCheck();
    } else if (currentState is AuthSessionExpired) {
      targetPage = const LoginPage(isSessionExpired: true);
    } else {
      targetPage = const LoginPage();
    }

    Navigator.of(context).pushReplacement(
      NavigateToPageWidget(targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset(
                AppImageKeys.sarLogo,
                height: 150.0,
                width: 150.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias
typedef SplashScreen = SplashPage;
