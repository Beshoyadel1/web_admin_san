import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/auth_cubit/auth_state.dart';
import 'login_devices_sizes_widget/login_web_widget.dart';
import 'login_widgets/session_expired_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.isSessionExpired = false,
  });

  final bool isSessionExpired;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isSessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          SessionExpiredDialog.show(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current is AuthSessionExpired,
      listener: (context, state) {
        if (state is AuthSessionExpired) {
          SessionExpiredDialog.show(context);
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              color: AppColors.scaffoldColor,
            ),
            child: const LoginWebWidget(),
          ),
        ),
      ),
    );
  }
}
