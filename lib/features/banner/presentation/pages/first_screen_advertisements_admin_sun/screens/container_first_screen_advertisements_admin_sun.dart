import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/banner/presentation/bloc/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/features/banner/presentation/pages/first_screen_advertisements_admin_sun/screens/list_data_first_screen_advertisements_admin_sun.dart';
import '../../../../../../core/theming/colors.dart';

class ContainerFirstScreenAdvertisementsAdminSun extends StatelessWidget {
  const ContainerFirstScreenAdvertisementsAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
            color: AppColors.greyColor.withOpacity(0.3)
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocProvider(
        create: (_) => BannerCubit()..getBanner(),
        child: const ListDataFirstScreenAdvertisementsAdminSun(),
      )
    );
  }
}