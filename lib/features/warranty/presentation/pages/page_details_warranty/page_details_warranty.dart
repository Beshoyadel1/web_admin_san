import 'package:flutter/material.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../features/warranty/presentation/pages/page_details_warranty/screens/warranty_data_content/warranty_data_content.dart';

class PageDetailsWarranty extends StatelessWidget {
  final int? warrantyId;

  const PageDetailsWarranty({
    super.key,
    this.warrantyId,
  });

  bool get isCreateMode => warrantyId == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: WarrantyDataContent(
          warrantyId: warrantyId,
        ),
      ),
    );
  }
}