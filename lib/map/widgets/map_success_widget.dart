import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_flutter/map/widgets/info_card_widget.dart';
import 'package:maps_flutter/map/widgets/zoom_in_out_widget.dart';

class MapSuccessWidget extends StatefulWidget {
  const MapSuccessWidget({
    Key? key,
    required this.locationData,
    required this.initLocation,
  }) : super(key: key);
  final LocationData locationData;
  final LatLng initLocation;

  @override
  State<MapSuccessWidget> createState() => _MapSuccessWidgetState();
}

class _MapSuccessWidgetState extends State<MapSuccessWidget> {
  MapboxMapController? mapController;

  _onMapCreated(MapboxMapController controller) async {
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
          myLocationEnabled: true,
          trackCameraPosition: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.locationData.latitude ?? widget.initLocation.latitude,
              widget.locationData.longitude ?? widget.initLocation.longitude,
            ),
            zoom: 9.0,
          ),
          onMapClick: (_, latlng) async {
            await mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: 10.0,
                  target: LatLng(
                    latlng.latitude,
                    latlng.longitude,
                  ),
                  tilt: 30.0,
                  zoom: 12.0,
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          child: InfoCardWidget(
            locationData: widget.locationData,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * .18,
          right: 10,
          child: ZoomInOutWidget(
            zoomInCallback: () async => await mapController?.animateCamera(
              CameraUpdate.zoomIn(),
            ),
            zoomOutCallback: () async => await mapController?.animateCamera(
              CameraUpdate.zoomOut(),
            ),
          ),
        ),
      ],
    );
  }
}
