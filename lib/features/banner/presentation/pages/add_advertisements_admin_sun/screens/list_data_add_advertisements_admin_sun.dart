import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/features/banner/data/model/get_banners_models/banner_model.dart';
import 'container_upload_image_in_list_data_add_advertisements_admin_sun.dart';
import 'part_of_time_start_end_admin_sun.dart';
import 'first_title_in_list_data_add_advertisements_admin_sun.dart';


class ListDataAddAdvertisementsAdminSun extends StatelessWidget {
  final BannerModel? banner;

  const ListDataAddAdvertisementsAdminSun({
    super.key,
    this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        const FirstTitleInListDataAddAdvertisementsAdminSun(),
         ContainerUploadImageInListDataAddAdvertisementsAdminSun(
          banner: banner,
        ),
        PartOfTimeStartEndAdminSun(
          banner: banner,
        ),
      ],
    );
  }
}