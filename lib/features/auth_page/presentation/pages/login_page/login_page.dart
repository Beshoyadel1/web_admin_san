import 'package:flutter/material.dart';
import 'package:web_admin_san/features/notifications/presentation/pages/signalR_status_bar/signalR_status_bar.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';
import 'login_devices_sizes_widget/login_web_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.scaffoldColor,
        ),
        child: const LoginWebWidget(),

      ),
    //  bottomNavigationBar: const SignalRStatusBar(),
    );
  }
}
