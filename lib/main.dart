import 'package:flutter/material.dart';
import 'package:mathgasing/routes/app_route_const.dart';
import 'package:mathgasing/routes/app_route_switch.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/pages/map_unit_level.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      // initialRoute: AppRouteConstants.mapunitlevelscreen,
      // onGenerateRoute: AppRouterSwitch.onGenerateRoute,
      home: MapUnitLevel(),
    );
  }
}
