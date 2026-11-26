import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import '../../../../../../core/helpers/constants/assets.dart';
import '../../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../../core/helpers/themes/fonts.dart';
import '../../../../../../core/helpers/themes/text_styles.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/wallet_balance_cubit/wallet_balance_cubit.dart';
import 'package:web_admin_san/feature/accounts_management_page/view_model/wallet_balance_cubit/wallet_balance_state.dart';

import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/row_text_icon_orange.dart';

class AccountBalance extends StatelessWidget {
  final ProviderDetailsRequest providerDetailsRequest;
  const AccountBalance({super.key, required this.providerDetailsRequest});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const TextInAppWidget(
          text: LocaleKeys.netBalance,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.blackColor,
        ),
        BlocProvider(
          create: (_) => WalletBalanceCubit()
            ..getWalletBalance(providerDetailsRequest: providerDetailsRequest),
          child: BlocBuilder<WalletBalanceCubit, WalletBalanceState>(
            builder: (context, state) {
              if (state is WalletBalanceLoading) {
                return const CupertinoActivityIndicator();
              }

              if (state is WalletBalanceError) {
                return const SizedBox();
              }

              if (state is WalletBalanceSuccess) {
                return RowTextIconOrange(
                  text: state.balance.toString(),
                  imagePath: AppImageKeys.coin,
                  textSize: 20,
                  textColor: AppColors.orangeColor,
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
