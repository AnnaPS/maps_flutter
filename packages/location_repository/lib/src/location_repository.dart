import 'package:location/location.dart';

/// {@template location_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class LocationRepository {
  /// {@macro location_repository}
  LocationRepository({
    Location? location,
  }) : _location = location ?? Location();
  final Location _location;

  Future<LocationData> getUserLocation() async => _location.getLocation();

  Future<bool> isServiceEnable() async {
    if (!await _location.serviceEnabled()) {
      await _location.requestService();
      if (!await _location.serviceEnabled()) {
        return false;
      }
    }
    return true;
  }

  Future<bool> hasPermissions() async {
    if (await _location.hasPermission() == PermissionStatus.denied) {
      await _location.requestPermission();
      if (await _location.hasPermission() != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}
