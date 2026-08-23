import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/coupon/data/request/get_coupon_statistics_request/get_coupon_statistics_request.dart';
import 'package:web_admin_san/features/coupon/presentation/pages/page_details_coupons/screens/package_data_content/coupon_statistics_widget.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import '../../../../../../../features/coupon/data/model/coupon_model/coupon_model.dart';
import '../../../../../../../features/coupon/presentation/bloc/coupon_cubit/coupon_cubit.dart';
import '../../../../../../../features/coupon/presentation/bloc/coupon_cubit/coupon_state.dart';
import '../../../../../../../features/coupon/presentation/custom_widget/coupon_discount_type_widget.dart';
import '../../../../../../../features/coupon/presentation/custom_widget/coupon_status_widget.dart';

class CouponsDataContent extends StatefulWidget {
  final int couponId;

  const CouponsDataContent({
    super.key,
    required this.couponId,
  });

  @override
  State<CouponsDataContent> createState() =>
      _CouponsDataContentState();
}

class _CouponsDataContentState
    extends State<CouponsDataContent> {

  bool _providersRequested = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.orangeColor,

      onRefresh: () async {
        _providersRequested = false;

        await context.read<CouponCubit>().getCouponDetails(
          couponId: widget.couponId,
        );
      },

      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: SizedBox(
        width: double.infinity,

        child: BlocBuilder<CouponCubit, CouponState>(
          builder: (
              context,
              state,
              ) {

            final cubit =
            context.read<CouponCubit>();

            // =========================================
            // LOADING
            // =========================================

            if (state is CouponLoading &&
                cubit.currentCoupon == null) {
              return const SizedBox(
                height: 400,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            // =========================================
            // ERROR
            // =========================================

            if (state is CouponFailure &&
                cubit.currentCoupon == null) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: TextInAppWidget(
                    text: state.message,
                    textSize: 15,
                    textColor: AppColors.greyColor,
                    isTextCenter: true,
                  ),
                ),
              );
            }

            // =========================================
            // COUPON DATA
            // =========================================

            if (cubit.currentCoupon != null) {
              return _buildContent(
                context,
                cubit.currentCoupon!,
              );
            }

            return const SizedBox(
              height: 300,
            );
          },
        ),
      ),
    ),
    );
  }
}

Widget _buildContent(
    BuildContext context,
    CouponWithProviderModel data,
    ) {
  final coupon = data.coupon;

  return Column(
    spacing: 20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const TextInAppWidget(
        text: AppLanguageKeys.statistics,
        textSize: 16,
        fontWeightIndex:
        FontSelectionData.mediumFontFamily,
        textColor: AppColors.orangeColor,
      ),

      CouponStatisticsWidget(
        couponId: coupon.couponId ?? 0,
      ),
      const TextInAppWidget(
        text: AppLanguageKeys.couponInformation,
        textSize: 16,
        fontWeightIndex:
        FontSelectionData.mediumFontFamily,
        textColor: AppColors.orangeColor,
      ),

      Wrap(
        spacing: 15,
        runSpacing: 15,
        children: [
          _infoField(
            title: AppLanguageKeys.identity,
            value: coupon.couponId?.toString() ?? '-',
          ),

          _infoField(
            title: AppLanguageKeys.couponCode,
            value: coupon.couponCode ?? '-',
          ),

          _infoField(
            title: AppLanguageKeys.discountValue,
            value: _formatNumber(
              coupon.discountValue,
            ),
          ),

          _infoField(
            title: AppLanguageKeys.maxDiscountValue,
            value: _formatNumber(
              coupon.maxDiscountValue,
            ),
          ),

          _infoField(
            title: AppLanguageKeys.minValueToApply,
            value: _formatNumber(
              coupon.minValueToApply,
            ),
          ),

          _infoField(
            title: AppLanguageKeys.usersUseCount,
            value:
            coupon.usersUseCount?.toString() ?? '-',
          ),

          _infoField(
            title: AppLanguageKeys.oneUserUseCount,
            value:
            coupon.oneUserUseCount?.toString() ?? '-',
          ),
        ],
      ),

      const TextInAppWidget(
        text: AppLanguageKeys.discountType,
        textSize: 16,
        fontWeightIndex:
        FontSelectionData.mediumFontFamily,
        textColor: AppColors.orangeColor,
      ),

      CouponDiscountTypeWidget(
        discountType: coupon.discountType,
      ),

      const TextInAppWidget(
        text: AppLanguageKeys.date,
        textSize: 16,
        fontWeightIndex:
        FontSelectionData.mediumFontFamily,
        textColor: AppColors.orangeColor,
      ),

      Wrap(
        spacing: 15,
        runSpacing: 15,
        children: [
          _infoField(
            title: AppLanguageKeys.startDate,
            value: coupon.couponStartDate == null
                ? '-'
                : _formatDate(
              coupon.couponStartDate!,
            ),
          ),

          _infoField(
            title: AppLanguageKeys.endDate,
            value: coupon.couponEndDate == null
                ? '-'
                : _formatDate(
              coupon.couponEndDate!,
            ),
          ),
        ],
      ),

      const TextInAppWidget(
        text: AppLanguageKeys.status,
        textSize: 16,
        fontWeightIndex:
        FontSelectionData.mediumFontFamily,
        textColor: AppColors.orangeColor,
      ),

      CouponStatusWidget(
        isActive: coupon.isActive,
        endDate: coupon.couponEndDate,
      ),

      const TextInAppWidget(
        text: AppLanguageKeys.serviceProviders,
        textSize: 16,
        fontWeightIndex:
        FontSelectionData.mediumFontFamily,
        textColor: AppColors.orangeColor,
      ),

      _buildProviders(
        context,
        data.providers,
      ),
    ],
  );
}

// ===================================================
// INFO FIELD
// ===================================================

Widget _infoField({
  required String title,
  required String value,
}) {
  return UserTextFieldWidget(
    controller: TextEditingController(
      text: value,
    ),
    text: title,
    readOnly: true,
    width: 250,
  );
}

// ===================================================
// PROVIDERS
// ===================================================

Widget _buildProviders(
    BuildContext context,
    List<int> providers,
    ) {
  if (providers.isEmpty) {
    return const TextInAppWidget(
      text: '-',
      textSize: 14,
      textColor: AppColors.greyColor,
    );
  }

  final cubit = context.read<CouponCubit>();

  return Wrap(
    spacing: 10,
    runSpacing: 10,
    children: providers.map(
          (providerId) {

        final provider =
        cubit.providerUsers[providerId];

        final providerName =
            provider?.providerDetails?.name ??
                provider?.username ??
                providerId.toString();

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.orangeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.orangeColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.business_outlined,
                size: 15,
                color: AppColors.orangeColor,
              ),

              const SizedBox(width: 6),

              TextInAppWidget(
                text: providerName,
                textSize: 13,
                fontWeightIndex:
                FontSelectionData.mediumFontFamily,
                textColor:
                AppColors.orangeColor,
              ),
            ],
          ),
        );
      },
    ).toList(),
  );
}

// ===================================================
// NUMBER
// ===================================================

String _formatNumber(double? value) {
  if (value == null) {
    return '-';
  }

  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toString();
}

// ===================================================
// DATE
// ===================================================

String _formatDate(DateTime date) {
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}