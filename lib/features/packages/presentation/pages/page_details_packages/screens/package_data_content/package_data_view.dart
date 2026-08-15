import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/features/packages/presentation/pages/page_details_packages/screens/package_data_content/package_data_content.dart';
import '../../../../../../../features/packages/presentation/bloc/packages_cubit/packages_cubit.dart';

class PackageDataContent extends StatelessWidget {
  final int packageId;

  const PackageDataContent({
    super.key,
    required this.packageId,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return BlocProvider(
      create: (_) => PackagesCubit()
        ..getPackageById(
          packageId: packageId,
        ),
      child: PackageDataView(
        packageId: packageId,
      ),
    );
  }
}

