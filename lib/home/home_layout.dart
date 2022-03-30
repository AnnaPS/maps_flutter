import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_flutter/location/bloc/location_bloc.dart';
import 'package:maps_flutter/location/bloc/location_state.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeState();
}

class _HomeState extends State<HomeLayout> {
  MapboxMapController? mapController;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          // if (state.status.isSuccess) {
          //   state.location.onLocationChanged.listen((l) {
          //     mapController?.animateCamera(
          //       CameraUpdate.newCameraPosition(
          //         CameraPosition(
          //             target: LatLng(l.latitude ?? 0.0, l.longitude ?? 0.0),
          //             zoom: 15),
          //       ),
          //     );
          //   });
          // }
          // TODO: implement new method to change camera position
        },
        builder: (context, state) {
          return state.status.isSuccess
              ? Stack(
                  children: [
                    MapboxMap(
                      styleString: MapboxStyles.OUTDOORS,
                      accessToken: dotenv.get('MAPBOX_ACCESS_TOKEN'),
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                            state.locationData.latitude ??
                                state.initLocation.latitude,
                            state.locationData.longitude ??
                                state.initLocation.longitude,
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
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                const Text('You are currently here:'),
                                Text(
                                    'Longitude: ${state.locationData.longitude} - Latitude: ${state.locationData.latitude}',
                                    style:
                                        const TextStyle(color: Colors.indigo)),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    mapController
                                        ?.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                              bearing: 10.0,
                                              target: LatLng(
                                                state.locationData.latitude ??
                                                    state.initLocation.latitude,
                                                state.locationData.longitude ??
                                                    state
                                                        .initLocation.longitude,
                                              ),
                                              tilt: 30.0,
                                              zoom: 17.0,
                                            ),
                                          ),
                                        )
                                        .then((result) => print(
                                            "mapController.animateCamera() returned $result"));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Where do you wanna go today?'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
