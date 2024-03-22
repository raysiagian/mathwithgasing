import 'package:mathgasing/routes/app_route_config.dart';
import 'package:mathgasing/routes/app_route_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppRouterSwritch {
  static Route? onGenerateRoute(RouteSettings settings) {
    if (kDebugMode) {
      print('===> ${settings.name}');
    }

    switch (settings.name) {
      case AppRouteConstants.splashscreen:
        return AppRouter.splashScreen();
      case AppRouteConstants.homescreen:
        return AppRouter.homeScreen();
      case AppRouteConstants.profilescreen:
        return AppRouter.profileScreen();
      case AppRouteConstants.loginscreen:
        return AppRouter.loginScreen();
      case AppRouteConstants.registerscreen:
        return AppRouter.registerScreen();
      default:
        onErrorRoute();
    }
    return null;
  }

  static onErrorRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('Error, Not found Route'),
        ),
      ),
    );
  }
}