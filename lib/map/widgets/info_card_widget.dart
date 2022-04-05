import 'package:flutter/material.dart';
import 'package:location_repository/location_repository.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    Key? key,
    required this.currentUserLocation,
  }) : super(key: key);
  final CurrentUserLocationEntity currentUserLocation;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi there!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('You are currently here:'),
              Text(
                'Longitude: ${currentUserLocation.longitude} - Latitude: ${currentUserLocation.latitude}',
                style: const TextStyle(color: Colors.indigo),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
