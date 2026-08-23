import 'package:flutter/material.dart';
import 'package:web_admin_san/features/packages/presentation/pages/page_details_packages/screens/package_data_content/package_data_view.dart';
import '../../../../../../core/theming/colors.dart';


class PageDetailsPackages extends StatelessWidget {
  final int? packageID;
  final bool isCreateMode;

  const PageDetailsPackages({
    super.key,
    this.packageID,
    this.isCreateMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      backgroundColor: AppColors.scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PackageDataContent(
          packageId: packageID,
          isCreateMode: isCreateMode,
        ),
      ),
    );
  }
}