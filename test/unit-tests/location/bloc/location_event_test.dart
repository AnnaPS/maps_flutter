import 'package:flutter_test/flutter_test.dart';
import 'package:maps_flutter/location/bloc/location_bloc.dart';

void main() {
  group('LocationStateStatusX', () {
    test('returns correct values for LocationStateStatus.initial', () {
      const status = LocationStateStatus.initial;
      expect(status.isInitial, isTrue);
      expect(status.isLoading, isFalse);
      expect(status.isSuccess, isFalse);
      expect(status.isError, isFalse);
    });
    test('returns correct values for LocationStateStatus.loading', () {
      const status = LocationStateStatus.loading;
      expect(status.isInitial, isFalse);
      expect(status.isLoading, isTrue);
      expect(status.isSuccess, isFalse);
      expect(status.isError, isFalse);
    });
    test('returns correct values for LocationStateStatus.success', () {
      const status = LocationStateStatus.success;
      expect(status.isInitial, isFalse);
      expect(status.isLoading, isFalse);
      expect(status.isSuccess, isTrue);
      expect(status.isError, isFalse);
    });
    test('returns correct values for LocationStateStatus.error', () {
      const status = LocationStateStatus.error;
      expect(status.isInitial, isFalse);
      expect(status.isLoading, isFalse);
      expect(status.isSuccess, isFalse);
      expect(status.isError, isTrue);
    });
  });
}
