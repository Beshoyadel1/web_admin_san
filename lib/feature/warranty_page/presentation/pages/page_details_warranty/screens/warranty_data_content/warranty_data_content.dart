import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/feature/warranty_page/view_model/warranty_cubit.dart';
import 'package:web_admin_san/feature/warranty_page/presentation/pages/page_details_warranty/screens/warranty_data_content/warranty_data_view.dart';

class WarrantyDataContent extends StatelessWidget {
  final int? warrantyId;

  const WarrantyDataContent({
    super.key,
    this.warrantyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = WarrantyCubit();

        if (warrantyId != null) {
          cubit.getApprovalInfoById(
            id: warrantyId!,
          );
        }

        return cubit;
      },
      child: WarrantyDataView(
        isCreateMode: warrantyId == null,
      ),
    );
  }
}
