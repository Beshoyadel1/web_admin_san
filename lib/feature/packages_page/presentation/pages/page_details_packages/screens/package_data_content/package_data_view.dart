import 'package:flutter/material.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/page_details_packages.dart';

class PackageDataContent extends StatelessWidget {
  final int? packageId;
  final bool isCreateMode;

  const PackageDataContent({
    super.key,
    this.packageId,
    this.isCreateMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return PageDetailsPackages(
      packageID: packageId,
    );
  }
}
