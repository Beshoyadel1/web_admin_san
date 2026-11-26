import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/colors/app_colors.dart';
import '../../../../../core/helpers/themes/fonts.dart';
import '../../../../../core/helpers/themes/text_styles.dart';
import '../../../../internal_services/data/model/get_provider_orders_model/order_model.dart';
import '../../../../internal_services/data/request/get_order_details_request/get_order_details_datasource.dart';
import '../../../../internal_services/view_model/get_order_details_cubit/get_order_details_cubit.dart';
import '../../../../internal_services/view_model/get_order_details_cubit/get_order_details_state.dart';
import 'widgets/order_details_error_card.dart';
import 'widgets/order_details_main_widget.dart';
import 'widgets/order_details_skeleton.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel? order;
  final int? orderId;

  const OrderDetails({
    super.key,
    this.order,
    this.orderId,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final ScrollController _scrollController = ScrollController();

  int get _effectiveOrderId => widget.order?.id ?? widget.orderId ?? 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetOrderDetailsCubit(
        getOrderDetailsDatasource: GetOrderDetailsDatasource(
          orderId: _effectiveOrderId,
        ),
      )..getOrderDetails(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.darkColor,
                size: 18,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInAppWidget(
                text: LocaleKeys.orderDetailsHeader.tr(),
                textSize: 16,
                textColor: AppColors.darkColor,
                fontWeightIndex: FontSelectionData.boldFontFamily,
              ),
              if (_effectiveOrderId > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextInAppWidget(
                    text: '#$_effectiveOrderId',
                    textSize: 12,
                    textColor: AppColors.orangeColor,
                    fontWeightIndex: FontSelectionData.boldFontFamily,
                  ),
                ),
              ],
            ],
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: AppColors.veryLightGreyColor,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
            builder: (context, state) {
              if (state is GetOrderDetailsLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: OrderDetailsSkeleton(),
                  ),
                );
              }

              if (state is GetOrderDetailsError) {
                return OrderDetailsErrorCard(
                  errorMessage: state.message,
                  onRetry: () {
                    context.read<GetOrderDetailsCubit>().getOrderDetails();
                  },
                );
              }

              if (state is GetOrderDetailsSuccess) {
                return Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: OrderDetailsMainWidget(
                      orderDetails: state.orderDetails,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
