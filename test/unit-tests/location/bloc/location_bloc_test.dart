import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_repository/location_repository.dart';
import 'package:maps_flutter/location/bloc/location_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements LocationRepository {}

class MockCurrentUserLocation extends Mock
    implements CurrentUserLocationEntity {}

void main() {
  late LocationRepository locationRepository;
  late CurrentUserLocationEntity currentUserLocationEntity;
  setUp(() {
    locationRepository = MockRepository();
    currentUserLocationEntity = MockCurrentUserLocation();
  });

  group('Location bloc', () {
    test(
      'Location bloc has [LocationStateStatus.initial] such first state',
      () {
        expect(LocationState().status.isInitial, isTrue);
      },
    );
  });

  test('Location bloc has [LocationStateStatus.initial] copyWith', () {
    expect(
      LocationState(),
      LocationState().copyWith(),
    );
  });

  blocTest<LocationBloc, LocationState>(
    'emits [LocationState.isLoading] - [LocationState.isSuccess] '
    'when location isServiceEnable and hasPermissions',
    setUp: () {
      when(() => locationRepository.getCurrentLocation()).thenAnswer(
        (_) async => currentUserLocationEntity,
      );
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
    expect: () => <LocationState>[
      LocationState().copyWith(status: LocationStateStatus.loading),
      LocationState().copyWith(
        status: LocationStateStatus.success,
        currentUserLocation: currentUserLocationEntity,
      )
    ],
    verify: (_) {
      verify(
        () => locationRepository.getCurrentLocation(),
      ).called(1);
    },
  );

  blocTest<LocationBloc, LocationState>(
    'emits [LocationState.isLoading] - [LocationState.isError] '
    'when repository throws CurrentLocationFailure because service is not enabled',
    setUp: () {
      when(() => locationRepository.getCurrentLocation()).thenThrow(
        CurrentLocationFailure(
          error: 'You don\'t have location service enabled',
        ),
      );
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
    errors: () => [
      isA<CurrentLocationFailure>(),
    ],
    expect: () => [
      LocationState().copyWith(status: LocationStateStatus.loading),
      isA<LocationState>()
        ..having(
          (element) => element.status,
          'error',
          equals(LocationStateStatus.error),
        ),
    ],
  );

  blocTest<LocationBloc, LocationState>(
    'emits [LocationState.isLoading] - [LocationState.isError] '
    'when repository throws CurrentLocationFailure because'
    ' user don\'t have permissions',
    setUp: () {
      when(() => locationRepository.getCurrentLocation()).thenThrow(
        CurrentLocationFailure(
          error:
              'You don\'t have all the permissions granted.\nYou need to activate them manually.',
        ),
      );
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
    errors: () => [
      isA<CurrentLocationFailure>(),
    ],
    expect: () => <LocationState>[
      LocationState().copyWith(status: LocationStateStatus.loading),
      LocationState().copyWith(
          status: LocationStateStatus.error,
          errorMessage:
              'You don\'t have all the permissions granted.\nYou need to activate them manually.')
    ],
  );

  blocTest<LocationBloc, LocationState>(
    'emits [LocationState.isLoading] - [LocationState.isError] '
    'when repository catch and exception',
    setUp: () {
      when(() => locationRepository.getCurrentLocation()).thenThrow(
        CurrentLocationFailure(
          error:
              'Something went wrong getting your location, please try again later.',
        ),
      );
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
    errors: () => [
      isA<CurrentLocationFailure>(),
    ],
    expect: () => <LocationState>[
      LocationState().copyWith(status: LocationStateStatus.loading),
      LocationState().copyWith(
          status: LocationStateStatus.error,
          errorMessage:
              'Something went wrong getting your location, please try again later.')
    ],
  );
}
