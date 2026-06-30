import 'package:flutter/material.dart';
import 'package:web_admin_san/core/theming/colors.dart';
import 'content_driver_details.dart';

class DriverDetailsPage extends StatelessWidget {
  final int driverId;

  const DriverDetailsPage({
    super.key,
    required this.driverId,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
      ),
      body:  ContentDriverDetails(
        driverId:driverId,
      ),
    );
  }
}
