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

  Future<LocationData> getUserLocation() async {
    final locationData = await _location.getLocation();
    return locationData;
  }

  Future<bool> isServiceEnable() async {
    var _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<bool> hasPermissions() async {
    var _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
