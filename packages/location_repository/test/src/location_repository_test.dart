import 'package:location/location.dart';
import 'package:location_repository/location_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockRepository extends Mock implements LocationRepository {}

void main() {
  late LocationRepository locationRepository;

  setUp(() {
    locationRepository = MockRepository();
  });
  test('can be instantiated', () {
    expect(LocationRepository(), isNotNull);
  });

  group('LocationRepository methods', () {
    test('Get User Location', () async {
      final locationDataFromMap = LocationData.fromMap(<String, dynamic>{
        'latitude': 40.4167,
        'longitude': -3.70325,
      });
      when(() => LocationRepository().getUserLocation()).thenAnswer(
        (_) async => Future.value(locationDataFromMap),
      );
      await LocationRepository().getUserLocation();
      verify(() => LocationRepository().getUserLocation()).called(1);
    });

    test('Service is NOT Enabled', () async {
      const isServiceEnable = false;
      when(() => LocationRepository().isServiceEnable())
          .thenAnswer((_) => Future.value(isServiceEnable));
      await Location().requestService();
      expect(LocationRepository().isServiceEnable(), isServiceEnable);
    });

    test('Service is NOT Enabled, requestService', () async {
      const isServiceEnabled = false;

      when(() => Location().requestService())
          .thenAnswer((_) => Future.value(isServiceEnabled));
      await Location().requestService();

      expect(Location().requestService(), isServiceEnabled);
    });

    test('Has permissions', () async {
      when(() async => Location().hasPermission())
          .thenAnswer((_) => Future.value(PermissionStatus.denied));
      when(() async => Location().requestPermission())
          .thenAnswer((_) => Future.value(PermissionStatus.granted));
      await Location().requestPermission();
      expect(await LocationRepository().hasPermissions(), true);

      // verify(() async => Location().hasPermission()).called(1);
    });

    test('Not Has permissions', () async {
      when(() => LocationRepository().hasPermissions())
          .thenAnswer((_) => Future.value(false));
      expect(await LocationRepository().hasPermissions(), false);
    });
  });
}
