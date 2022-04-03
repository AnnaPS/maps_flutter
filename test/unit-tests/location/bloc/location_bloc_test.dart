import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_repository/location_repository.dart';
import 'package:maps_flutter/location/bloc/location_bloc.dart';
import 'package:maps_flutter/util/location_helper.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements LocationRepository {}

void main() {
  late LocationRepository locationRepository;
  setUp(() {
    locationRepository = MockRepository();
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
    'when repository isServiceEnable, hasPermissions and returns the location',
    setUp: () {
      when(() => locationRepository.isServiceEnable()).thenAnswer(
        (_) => Future.value(true),
      );
      when(() => locationRepository.hasPermissions()).thenAnswer(
        (_) => Future.value(true),
      );
      when(() => locationRepository.getUserLocation()).thenAnswer(
        (_) async => Future.value(
          LocationHelper.locationDataFromMap,
        ),
      );
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
    expect: () => <LocationState>[
      LocationState().copyWith(status: LocationStateStatus.loading),
      LocationState().copyWith(
          status: LocationStateStatus.success,
          locationData: LocationHelper.locationDataFromMap)
    ],
    verify: (_) {
      verify(
        () => locationRepository.getUserLocation(),
      ).called(1);
    },
  );

  blocTest<LocationBloc, LocationState>(
    'emits [LocationState.isLoading] - [LocationState.isError] '
    'when repository isServiceEnable is FALSE, hasPermissions is TRUE',
    setUp: () {
      when(() => locationRepository.isServiceEnable()).thenAnswer(
        (_) => Future.value(false),
      );
      when(() => locationRepository.hasPermissions()).thenAnswer(
        (_) => Future.value(true),
      );
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
    expect: () => <LocationState>[
      LocationState().copyWith(status: LocationStateStatus.loading),
      LocationState().copyWith(
          status: LocationStateStatus.error,
          errorMessage: 'You don\'t have location service enabled')
    ],
  );

  blocTest<LocationBloc, LocationState>(
    'emits [LocationState.isLoading] - [LocationState.isError] '
    'when repository isServiceEnable is TRUE, hasPermissions is FALSE',
    setUp: () {
      when(() => locationRepository.isServiceEnable()).thenAnswer(
        (_) => Future.value(true),
      );
      when(() => locationRepository.hasPermissions()).thenAnswer(
        (_) => Future.value(false),
      );
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
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
      when(() => locationRepository.isServiceEnable()).thenAnswer(
        (_) => Future.value(true),
      );
      when(() => locationRepository.hasPermissions()).thenAnswer(
        (_) => Future.value(true),
      );
      when(() => locationRepository.getUserLocation())
          .thenThrow(isA<Exception>());
    },
    build: () => LocationBloc(locationRepository: locationRepository),
    act: (bloc) => bloc.add(GetLocation()),
    expect: () => <LocationState>[
      LocationState().copyWith(status: LocationStateStatus.loading),
      LocationState().copyWith(
          status: LocationStateStatus.error,
          errorMessage:
              'Something went wrong getting the your location, please try again later.')
    ],
    verify: (_) {
      verify(
        () => locationRepository.getUserLocation(),
      ).called(1);
    },
  );
}
