import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:location_repository/location_repository.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_flutter/util/location_helper.dart';

part 'location_state.dart';
part 'location_event.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({
    required this.locationRepository,
  }) : super(LocationState()) {
    on<GetLocation>(_getLocationEvent);
  }
  final LocationRepository locationRepository;

  void _getLocationEvent(GetLocation event, Emitter<LocationState> emit) async {
    try {
      emit(state.copyWith(status: LocationStateStatus.loading));
      final isServiceEnable = await locationRepository.isServiceEnable();
      final hasPermissions = await locationRepository.hasPermissions();

      if (isServiceEnable && hasPermissions) {
        var _currentLocation = await locationRepository.getUserLocation();

        emit(
          state.copyWith(
            locationData: _currentLocation,
            status: LocationStateStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
              status: LocationStateStatus.error,
              errorMessage: !isServiceEnable
                  ? 'You don\'t have location service enabled'
                  : 'You don\'t have all the permissions granted.\nYou need to activate them manually.'),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
            status: LocationStateStatus.error,
            errorMessage:
                'Something went wrong getting the your location, please try again later.'),
      );
    }
  }
}
