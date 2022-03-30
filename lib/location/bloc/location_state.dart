import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_flutter/util/location_helper.dart';

enum LocationStateStatus { initial, success, error, loading }

extension LocationStateStatusX on LocationStateStatus {
  bool get isInitial => this == LocationStateStatus.initial;
  bool get isSuccess => this == LocationStateStatus.success;
  bool get isError => this == LocationStateStatus.error;
  bool get isLoading => this == LocationStateStatus.loading;
}

class LocationState extends Equatable {
  LocationState({
    this.status = LocationStateStatus.initial,
    LatLng? initLocation,
    LocationData? locationData,
    Location? location,
  })  : locationData = locationData ?? LocationHelper.locationDataFromMap,
        location = location ?? Location(),
        initLocation = initLocation ?? const LatLng(40.4167, -3.70325);

  final LocationStateStatus status;
  final LocationData locationData;
  final LatLng initLocation;
  final Location location;

  @override
  List<Object?> get props => [
        status,
        locationData,
        location,
        initLocation,
      ];

  LocationState copyWith({
    LocationStateStatus? status,
    LocationData? locationData,
    LatLng? initLocation,
    Location? location,
  }) {
    return LocationState(
      status: status ?? this.status,
      locationData: locationData ?? this.locationData,
      initLocation: initLocation ?? this.initLocation,
      location: location ?? this.location,
    );
  }
}
