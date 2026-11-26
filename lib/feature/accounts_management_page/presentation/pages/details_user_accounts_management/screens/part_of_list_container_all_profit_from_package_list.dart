import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/widgets/custom_container.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/accounts_management_page/presentation/widgets/design_container_image_with_two_text_widget.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/provider_balances_cubit/provider_balances_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/provider_balances_cubit/provider_balances_state.dart';
import '../../../../../../core/helpers/constants/assets.dart';

class PartOfListContainerInFirstScreenAccountsManagementAdminSun
    extends StatelessWidget {
  const PartOfListContainerInFirstScreenAccountsManagementAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: LocaleKeys.accountBalanceKey,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),
        BlocBuilder<ProviderBalanceCubit, ProviderBalanceState>(
          builder: (context, state) {
            if (state is ProviderBalanceLoading) {
              return const CupertinoActivityIndicator();
            }

            if (state is ProviderBalanceError) {
              return const SizedBox();
            }

            if (state is ProviderBalanceSuccess) {
              final model = state.model;

              return _buildRow(
                model.totalBalance.toString(),
                model.electronicBalance.toString(),
                model.cashBalance.toString(),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildRow(String total, String electronic, String cash) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: [
        CustomContainer(
          isSelected: false,
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          typeWidget: DesignContainerImageWithTwoTextWidget(
            imagePath: AppImageKeys.account_sun2,
            title: LocaleKeys.allPayments,
            subTitle: total,
          ),
        ),
        CustomContainer(
          isSelected: false,
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          typeWidget: DesignContainerImageWithTwoTextWidget(
            imagePath: AppImageKeys.account_sun2,
            title: LocaleKeys.cardPayments,
            subTitle: electronic,
          ),
        ),
        CustomContainer(
          isSelected: false,
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          typeWidget: DesignContainerImageWithTwoTextWidget(
            imagePath: AppImageKeys.account_sun2,
            title: LocaleKeys.cashOnDeliveryPayments,
            subTitle: cash,
          ),
        ),
      ],
    );
  }
}
