import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/banner/data/model/get_banners_models/banner_model.dart';

import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../bloc/banner_cubit/banner_cubit.dart';
import '../../../bloc/banner_cubit/banner_state.dart';

class ContainerUploadImageInListDataAddAdvertisementsAdminSun
    extends StatelessWidget {
  final BannerModel? banner;

  const ContainerUploadImageInListDataAddAdvertisementsAdminSun({
    super.key,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        final cubit = context.read<BannerCubit>();

        return InkWell(
          onTap: cubit.pickImage,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 20,
            ),
            decoration: const BoxDecoration(
              color: AppColors.blackColor25,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (cubit.imageBytes != null)
                  Image.memory(
                    cubit.imageBytes!,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                else if (banner?.image != null)
                  Image.memory(
                    banner!.image!,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                else
                  const Icon(Icons.image,color: AppColors.whiteColor,size: 50,),
                const SizedBox(height: 10),
                const TextInAppWidget(
                  text: AppLanguageKeys.uploadImageWithData,
                  textSize: 14,
                  fontWeightIndex: FontSelectionData.mediumFontFamily,
                  textColor: AppColors.darkGreyColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
