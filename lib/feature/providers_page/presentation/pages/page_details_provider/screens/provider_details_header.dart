import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/constants/assets.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_cubit.dart';
import 'package:web_admin_san/feature/auth_page/view_model/get_user_info_cubit/get_user_info_state.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';

class ProviderDetailsHeader extends StatelessWidget {
  final int providerID;

  const ProviderDetailsHeader({
    super.key,
    required this.providerID,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserInfoCubit, GetUserInfoState>(
      builder: (context, state) {
        String name = LocaleKeys.serviceProviderName.tr();
        Uint8List? imageBytes;

        if (state is GetUserInfoSuccess) {
          name = state.user.providerDetails?.name ??
              state.user.username ??
              LocaleKeys.serviceProviderName.tr();
          imageBytes = state.user.image;
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    AppColors.veryLightOrangeColor.withValues(alpha: 0.3),
                backgroundImage:
                    imageBytes != null ? MemoryImage(imageBytes) : null,
                child: imageBytes == null
                    ? Image.asset(
                        AppImageKeys.profileImage,
                        width: 26,
                        height: 26,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person_rounded,
                          color: AppColors.orangeColor,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '#$providerID',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
