import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'content_driver_details.dart';

class DriverDetailsPage extends StatelessWidget {
  const DriverDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: const ContentDriverDetails(),
    );
  }
}