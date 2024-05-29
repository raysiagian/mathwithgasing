import 'package:flutter/material.dart';
import 'package:mathgasing/routes/app_route_const.dart';
import 'package:mathgasing/routes/app_route_switch.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      title: 'MyApp',
      initialRoute: AppRouteConstants.splashscreen,
      onGenerateRoute: AppRouterSwitch.onGenerateRoute,
    );
  }
}
