import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/widgets/custom_container.dart';
import '../../../../../../../../core/widgets/navigate_to_page_widget.dart';
import 'package:web_admin_san/feature/internal_services/presentation/pages/internal_orders/widgets/text_empty_view_data.dart';
import 'package:web_admin_san/feature/warranty_page/view_model/warranty_cubit.dart';
import 'package:web_admin_san/feature/warranty_page/view_model/warranty_state.dart';
import 'package:web_admin_san/feature/warranty_page/presentation/widgets/widget_design_list_warranty.dart';
import 'package:web_admin_san/feature/warranty_page/presentation/pages/page_details_warranty/page_details_warranty.dart';

class ListWarrantyPage extends StatelessWidget {
  const ListWarrantyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarrantyCubit, WarrantyState>(
      builder: (context, state) {
        if (state is WarrantyLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is WarrantyError) {
          return Center(
            child: Text(state.message),
          );
        }

        if (state is WarrantySuccess) {
          if (state.warranties.isEmpty) {
            return const Center(
              child: TextEmptyViewData(),
            );
          }

          return CustomContainer(
            isSelected: false,
            onTap: () {},
            typeWidget: ListView.separated(
              itemCount: state.warranties.length,
              separatorBuilder: (_, __) {
                return const SizedBox(
                  height: 20,
                );
              },
              itemBuilder: (context, index) {
                final warranty = state.warranties[index];

                return WidgetDesignListWarranty(
                  warrantyId: warranty.id,
                  price: warranty.price,
                  durationTypeId: warranty.durationtype,
                  durationValue: warranty.durationvalue,
                  onTapDetails: () async {
                    final id = warranty.id;

                    if (id == null || id <= 0) {
                      return;
                    }

                    final result = await Navigator.push(
                      context,
                      NavigateToPageWidget(
                        PageDetailsWarranty(
                          warrantyId: id,
                        ),
                      ),
                    );

                    if (result == true && context.mounted) {
                      await context.read<WarrantyCubit>().getApprovals();
                    }
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
