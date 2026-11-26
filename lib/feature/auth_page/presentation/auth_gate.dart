import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'package:web_admin_san/feature/auth_page/presentation/pages/login_page/login_page.dart';
import 'package:web_admin_san/feature/facility_account_page/presentation/facility_account_check.dart';
import '../../store_page/presentation/pages/store_page.dart';

import 'pages/splash_page/splash_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const SplashPage();
        }

        if (state is AuthIncompleteProfile ||
            state is AuthUpdateLoading ||
            state is AuthUpdateSuccess ||
            state is AuthUpdateError) {
          return const FacilityAccountCheck();
        }

        if (state is AuthAuthenticated) {
          return const StorePage();
        }

        if (state is AuthSessionExpired) {
          return const LoginPage(isSessionExpired: true);
        }

        return const LoginPage();
      },
    );
  }
}
