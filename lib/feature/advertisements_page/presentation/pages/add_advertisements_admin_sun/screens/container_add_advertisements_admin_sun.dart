import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/get_banners_models/banner_model.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/pages/add_advertisements_admin_sun/screens/list_data_add_advertisements_admin_sun.dart';

import '../../../../../../core/helpers/colors/app_colors.dart';

class ContainerAddAdvertisementsAdminSun extends StatelessWidget {
  final BannerModel? banner;

  const ContainerAddAdvertisementsAdminSun({
    super.key,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: AppColors.greyColor200,
            blurRadius: 10,
            offset: Offset(0, 4),
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
