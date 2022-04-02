import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/location/bloc/location_bloc.dart';
import 'package:maps_flutter/location/widgets/location_error_widget.dart';
import 'package:maps_flutter/map/widgets/map_success.dart';

class MapLayout extends StatelessWidget {
  const MapLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          return state.status.isSuccess
              ? MapSuccess(
                  locationData: state.locationData,
                  initLocation: state.initLocation,
                )
              : state.status.isError
                  ? LocationErrorWidget(
                      errorMessage: state.errorMessage,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
        },
      ),
    );
  }
}
