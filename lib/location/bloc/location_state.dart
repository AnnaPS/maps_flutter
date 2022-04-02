part of 'location_bloc.dart';

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
    String? errorMessage,
  })  : locationData = locationData ?? LocationHelper.locationDataFromMap,
        location = location ?? Location(),
        initLocation = initLocation ?? const LatLng(40.4167, -3.70325),
        errorMessage = errorMessage ?? '';

  final LocationStateStatus status;
  final LocationData locationData;
  final LatLng initLocation;
  final Location location;
  final String errorMessage;

  @override
  List<Object?> get props => [
        status,
        locationData,
        location,
        initLocation,
        errorMessage,
      ];

  LocationState copyWith({
    LocationStateStatus? status,
    LocationData? locationData,
    LatLng? initLocation,
    Location? location,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      locationData: locationData ?? this.locationData,
      initLocation: initLocation ?? this.initLocation,
      location: location ?? this.location,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
