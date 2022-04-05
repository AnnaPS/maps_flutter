import 'package:location/location.dart';
import 'package:location_repository/location_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLocation extends Mock implements Location {}

void main() {
  late LocationRepository locationRepository;
  late Location location;

  setUp(() {
    location = MockLocation();
    locationRepository = LocationRepository(
      location: location,
    );
  });
  test('can be instantiated', () {
    expect(LocationRepository(), isNotNull);
  });

  group('getCurrentLocation', () {
    group('getCurrentLocation', () {
      test('throws CurrentLocationFailure when service is not enabled', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => false);
        when(() => location.requestService()).thenAnswer((_) async => false);

        expect(
          () => locationRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('throws PermissionsFailure when permission is not granted', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.denied,
        );
        when(() => location.requestPermission()).thenAnswer(
          (_) async => PermissionStatus.denied,
        );

        expect(
          () => locationRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('throws CurrentLocationFailure when location is unavailable', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.granted,
        );
        when(() => location.getLocation()).thenThrow(Exception());

        expect(
          () => locationRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('throws CurrentLocationFailure when location is null', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.granted,
        );
        when(() => location.getLocation()).thenAnswer(
          (_) async => LocationData.fromMap(<String, dynamic>{}),
        );

        expect(
          () => locationRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('returns CurrentUserLocation when location is available', () async {
        const latitude = 42.0;
        const longitude = 13.37;
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.granted,
        );
        when(() => location.getLocation()).thenAnswer(
          (_) async => LocationData.fromMap(
            <String, dynamic>{
              'latitude': latitude,
              'longitude': longitude,
            },
          ),
        );

        expect(
          await locationRepository.getCurrentLocation(),
          isA<CurrentUserLocationEntity>()
              .having((l) => l.latitude, 'latitude', latitude)
              .having((l) => l.longitude, 'longitude', longitude),
        );
      });
    });
  });
}
