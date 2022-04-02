import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maps_flutter/map/pages/map_page.dart';
import 'package:maps_flutter/util/bloc_observer.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox Flutter',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: const MapPage(),
    );
  }
}
