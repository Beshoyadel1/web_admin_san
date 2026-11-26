import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/widgets/snackbar.dart';
import 'package:web_admin_san/feature/advertisements_page/data/model/get_banners_models/banner_model.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/feature/advertisements_page/view_model/banner_cubit/banner_state.dart';
import 'package:web_admin_san/feature/advertisements_page/presentation/widgets/select_time_profit_service_widget.dart';

import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'last_button_in_list_data_add_advertisements_admin_sun.dart';

class PartOfTimeStartEndAdminSun extends StatelessWidget {
  final BannerModel? banner;

  const PartOfTimeStartEndAdminSun({
    super.key,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: LocaleKeys.durationFromTo,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        SelectTimeProfitServiceWidget(
          hint: '00/00/0000',
          initialDate: banner?.startDate,
          isTime: true,
          backGroundColor: AppColors.whiteColor,
          textColor: AppColors.greyColor,
          borderColor: AppColors.greyColor,
          width: 250,
          onDateSelected: (date) {
            context.read<BannerCubit>().setStartDate(date);
          },
        ),
        SelectTimeProfitServiceWidget(
          hint: '00/00/0000',
          initialDate: banner?.endDate,
          isTime: true,
          backGroundColor: AppColors.whiteColor,
          textColor: AppColors.greyColor,
          borderColor: AppColors.greyColor,
          width: 250,
          onDateSelected: (date) {
            context.read<BannerCubit>().setEndDate(date);
          },
        ),
        BlocListener<BannerCubit, BannerState>(
          listener: (context, state) {
            if (state is BannerCreateSuccess || state is BannerUpdateSuccess) {
              AppSnackBar.showSuccess(
                LocaleKeys.success,
              );

              Navigator.pop(context, true);
            }

            if (state is BannerError) {
              AppSnackBar.showError(
                state.message,
              );
            }
          },
          child: BlocBuilder<BannerCubit, BannerState>(
            builder: (context, state) {
              final isEdit = banner != null;

              return LastButtonInListDataAddAdvertisementsAdminSun(
                text: isEdit
                    ? LocaleKeys.updateBannerAd
                    : LocaleKeys.createBannerAd,
                isLoading: state is BannerCreateLoading ||
                    state is BannerUpdateLoading,
                onTap: (state is BannerCreateLoading ||
                        state is BannerUpdateLoading)
                    ? null
                    : () {
                        final cubit = context.read<BannerCubit>();

                        if (isEdit) {
                          cubit.updateBanner(
                            imageId: banner!.imageId!,
                          );
                        } else {
                          cubit.createBanner();
                        }
                      },
              );
            },
          ),
        )
      ],
    );
  }
}
