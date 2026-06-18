import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/features/banner/presentation/bloc/banner_cubit/banner_cubit.dart';
import 'package:web_admin_san/features/banner/presentation/pages/add_advertisements_admin_sun/add_advertisements_admin_sun.dart';
import 'package:web_admin_san/features/banner/presentation/pages/add_advertisements_admin_sun/screens/last_button_in_list_data_add_advertisements_admin_sun.dart';
import 'package:web_admin_san/features/banner/presentation/pages/first_screen_advertisements_admin_sun/screens/row_view_all_advertisements_uploaded.dart';

class ListDataFirstScreenAdvertisementsAdminSun extends StatelessWidget {
  const ListDataFirstScreenAdvertisementsAdminSun({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30,
      children: [
        const RowViewAllAdvertisementsUploaded(),

        LastButtonInListDataAddAdvertisementsAdminSun(
          text: AppLanguageKeys.createBannerAd,
          onTap: () async {
            final result = await Navigator.of(context).push(
              NavigateToPageWidget(
                const AddAdvertisementsAdminSun(),
              ),
            );

            if (result == true && context.mounted) {
              context.read<BannerCubit>().getBanner();
            }
          },
        ),
      ],
    );
  }
}