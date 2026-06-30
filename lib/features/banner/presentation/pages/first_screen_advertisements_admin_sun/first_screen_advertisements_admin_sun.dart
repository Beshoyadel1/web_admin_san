import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/banner/presentation/bloc/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/features/banner/presentation/pages/first_screen_advertisements_admin_sun/screens/container_first_screen_advertisements_admin_sun.dart';
import '../../../../../core/theming/colors.dart';


class FirstScreenAdvertisementsAdminSun extends StatelessWidget {
  const FirstScreenAdvertisementsAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (_) => BannerCubit()..getBanner(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: SafeArea(
              child: RefreshIndicator(
                color: AppColors.orangeColor,
                onRefresh: () async {
                  await context.read<BannerCubit>().getBanner();
                },
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ContainerFirstScreenAdvertisementsAdminSun(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
