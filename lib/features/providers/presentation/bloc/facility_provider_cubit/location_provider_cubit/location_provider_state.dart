import 'package:latlong2/latlong.dart';

abstract class LocationProviderState {}

class LocationInitial extends LocationProviderState {}

class LocationLoading extends LocationProviderState {}

class LocationLoaded extends LocationProviderState {
  final LatLng latLng;
  final String placeName;

  LocationLoaded(this.latLng, this.placeName);
}

class LocationError extends LocationProviderState {
  final String message;

  LocationError(this.message);
}
