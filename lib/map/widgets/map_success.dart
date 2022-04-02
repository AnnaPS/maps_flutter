import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapSuccess extends StatefulWidget {
  const MapSuccess(
      {Key? key, required this.locationData, required this.initLocation})
      : super(key: key);
  final LocationData locationData;
  final LatLng initLocation;

  @override
  State<MapSuccess> createState() => _MapSuccessState();
}

class _MapSuccessState extends State<MapSuccess> {
  MapboxMapController? mapController;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapboxMap(
          styleString: 'mapbox://styles/anapolo/cl1gia3ae001a14q4eahc8q55',
          accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.locationData.latitude ?? widget.initLocation.latitude,
                widget.locationData.longitude ?? widget.initLocation.longitude,
              ),
              zoom: 14.0),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Hi there!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text('You are currently here:'),
                    Text(
                        'Longitude: ${widget.locationData.longitude} - Latitude: ${widget.locationData.latitude}',
                        style: const TextStyle(color: Colors.indigo)),
                    const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     mapController
                    //         ?.animateCamera(
                    //           CameraUpdate.newCameraPosition(
                    //             CameraPosition(
                    //               bearing: 10.0,
                    //               target: LatLng(
                    //                 state.locationData.latitude ??
                    //                     state.initLocation.latitude,
                    //                 state.locationData.longitude ??
                    //                     state
                    //                         .initLocation.longitude,
                    //               ),
                    //               tilt: 30.0,
                    //               zoom: 17.0,
                    //             ),
                    //           ),
                    //         )
                    //         .then((result) => print(
                    //             "mapController.animateCamera() returned $result"));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       padding: const EdgeInsets.all(20)),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: const [
                    //       Text('Where do you wanna go today?'),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
