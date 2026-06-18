import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/features/banner/presentation/pages/first_screen_advertisements_admin_sun/screens/container_first_screen_advertisements_admin_sun.dart';
import '../../../../../core/theming/colors.dart';


class FirstScreenAdvertisementsAdminSun extends StatelessWidget {
  const FirstScreenAdvertisementsAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child:SingleChildScrollView(
              child: ContainerFirstScreenAdvertisementsAdminSun()
          ),
        ),
      ),
    );
  }
}
