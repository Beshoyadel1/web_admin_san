import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/location_provider_cubit/location_provider_cubit.dart';
import 'package:web_admin_san/features/providers/presentation/bloc/facility_provider_cubit/location_provider_cubit/location_provider_state.dart';
import 'package:web_admin_san/features/store_page/presentation/pages/store_widgets/flutter_map_widget.dart';

class SquareMapProviderWidget extends StatelessWidget {
  SquareMapProviderWidget({super.key});

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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is LocationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is LocationLoaded) {
          final center = state.latLng;
          return SizedBox(
            height: 200,
            child: FlutterMapWidget(
              centerLocation: center,
              mapController: mapController,
            ),
          );
        }
        if (state is LocationError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
