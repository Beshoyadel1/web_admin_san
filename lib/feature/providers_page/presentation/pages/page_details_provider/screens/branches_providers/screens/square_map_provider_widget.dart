import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/location_provider_cubit/location_provider_cubit.dart';
import 'package:web_admin_san/feature/providers_page/view_model/facility_provider_cubit/location_provider_cubit/location_provider_state.dart';
import 'package:web_admin_san/feature/store_page/presentation/pages/store_widgets/flutter_map_widget.dart';

class SquareMapProviderWidget extends StatelessWidget {
  final double height;

  SquareMapProviderWidget({
    super.key,
    this.height = 360,
  });

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationProviderCubit, LocationProviderState>(
      listener: (context, state) {
        if (state is LocationLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController.move(
              state.latLng,
              13,
            );
          });
        } else if (state is LocationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LocationInitial) {
          context.read<LocationProviderCubit>().getUserLocation();
          return SizedBox(
            height: height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is LocationLoading) {
          return SizedBox(
            height: height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is LocationLoaded) {
          final center = state.latLng;
          return SizedBox(
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FlutterMapWidget(
                centerLocation: center,
                mapController: mapController,
              ),
            ),
          );
        }
        if (state is LocationError) {
          return SizedBox(
            height: height,
            child: Center(
              child: Text(state.message),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
