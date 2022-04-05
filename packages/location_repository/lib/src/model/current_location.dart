class CurrentUserLocationEntity {
  const CurrentUserLocationEntity({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;

  static const empty = CurrentUserLocationEntity(latitude: 0, longitude: 0);
}
