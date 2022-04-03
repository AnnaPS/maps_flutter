import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/location/bloc/location_bloc.dart';
import 'package:maps_flutter/location/widgets/location_error_widget.dart';
import 'package:maps_flutter/map/widgets/map_success_widget.dart';

class MapLayout extends StatelessWidget {
  const MapLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        buildWhen: (previous, current) =>
            current.status.isLoading ||
            current.status.isError ||
            current.status.isSuccess,
        builder: (context, state) {
          if (state.status.isSuccess) {
            return MapSuccessWidget(
              locationData: state.locationData,
              initLocation: state.initLocation,
            );
          }
          if (state.status.isError) {
            return LocationErrorWidget(
              errorMessage: state.errorMessage,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
