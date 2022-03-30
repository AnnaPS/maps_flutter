import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/home/home_layout.dart';
import 'package:maps_flutter/location/bloc/location_bloc.dart';
import 'package:maps_flutter/location/bloc/location_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
      create: (context) => LocationBloc()..add(GetLocation()),
      child: const HomeLayout(),
    );
  }
}
