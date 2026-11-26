import 'package:flutter/material.dart';

import 'package:web_admin_san/feature/packages_page/data/model/get_packages_model/get_packages_model.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/widgets/package_basic_info_card.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/widgets/package_descriptions_card.dart';
import 'package:web_admin_san/feature/packages_page/presentation/pages/page_details_packages/widgets/package_details_header_card.dart';

class PackageDetailsDashboardView extends StatelessWidget {
  const PackageDetailsDashboardView({
    super.key,
    required this.package,
    required this.onEdit,
    required this.onDelete,
  });

  final PackageModel package;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSideBySide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              PackageDetailsHeaderCard(
                package: package,
                onEdit: onEdit,
                onDelete: onDelete,
              ),

              const SizedBox(height: 20),

              // Responsive Side-by-Side on desktop/tablet, stacked on mobile
              if (isSideBySide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: PackageBasicInfoCard(
                        package: package,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: PackageDescriptionsCard(
                        package: package,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PackageBasicInfoCard(
                      package: package,
                    ),
                    const SizedBox(height: 20),
                    PackageDescriptionsCard(
                      package: package,
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
