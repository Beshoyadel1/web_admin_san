import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/banner/data/model/get_banners_models/banner_model.dart';
import 'package:web_admin_san/features/banner/presentation/bloc/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/features/banner/presentation/pages/add_advertisements_admin_sun/screens/list_data_add_advertisements_admin_sun.dart';
import '../../../../../../core/theming/colors.dart';

class ContainerAddAdvertisementsAdminSun extends StatelessWidget {
  final BannerModel? banner;

  const ContainerAddAdvertisementsAdminSun({
    super.key,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocProvider(
        create: (context) {
          final cubit = BannerCubit();

          if (banner != null) {
            cubit.setBannerData(banner!);
          }

          return cubit;
        },
        child: ListDataAddAdvertisementsAdminSun(
          banner: banner,
        ),
      ),
    );
  }
}
