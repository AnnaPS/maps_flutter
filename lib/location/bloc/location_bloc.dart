import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:maps_flutter/location/bloc/location_event.dart';
import 'package:maps_flutter/location/bloc/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState()) {
    on<GetLocation>(_getLocationEvent);
  }

  void _getLocationEvent(GetLocation event, Emitter<LocationState> emit) async {
    try {
      Location location = Location();

      emit(state.copyWith(status: LocationStateStatus.loading));
      isServiceEnableAndHasPermission(location);
      var _currentPosition = await location.getLocation();
      emit(state.copyWith(
        locationData: _currentPosition,
        status: LocationStateStatus.success,
        location: location,
      ));
    } catch (_) {
      emit(state.copyWith(status: LocationStateStatus.error));
    }
  }

  void isServiceEnableAndHasPermission(Location location) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
