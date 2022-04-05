import 'package:location/location.dart';
import 'package:location_repository/src/model/current_location.dart';

class CurrentLocationFailure implements Exception {
  CurrentLocationFailure({
    required this.error,
  });
  final String error;
}

/// {@template location_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class LocationRepository {
  /// {@macro location_repository}
  LocationRepository({
    Location? location,
  }) : _location = location ?? Location();
  final Location _location;

  Future<CurrentUserLocationEntity> getCurrentLocation() async {
    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      final isEnabled = await _location.requestService();
      if (!isEnabled) {
        throw CurrentLocationFailure(
          error: "You don't have location service enabled",
        );
      }
    }

    final permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      final status = await _location.requestPermission();
      if (status != PermissionStatus.granted) {
        throw CurrentLocationFailure(
          error: "You don't have all the permissions granted."
              '\nYou need to activate them manually.',
        );
      }
    }

    late final LocationData locationData;
    try {
      locationData = await _location.getLocation();
    } catch (_) {
      throw CurrentLocationFailure(
        error: 'Something went wrong getting your location, '
            'please try again later',
      );
    }

    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      throw CurrentLocationFailure(
        error: 'Something went wrong getting your location, '
            'please try again later',
      );
    }

    return CurrentUserLocationEntity(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
