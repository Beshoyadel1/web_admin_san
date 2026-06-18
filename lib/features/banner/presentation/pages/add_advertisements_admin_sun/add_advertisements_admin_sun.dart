import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/features/banner/data/model/get_banners_models/banner_model.dart';
import 'package:web_admin_san/features/banner/presentation/pages/add_advertisements_admin_sun/screens/container_add_advertisements_admin_sun.dart';
import '../../../../../core/theming/colors.dart';

class AddAdvertisementsAdminSun extends StatelessWidget {
  final BannerModel? banner;

  const AddAdvertisementsAdminSun({
    super.key,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ContainerAddAdvertisementsAdminSun(
              banner: banner,
            ),
          ),
        ),
      ),
    );
  }
}