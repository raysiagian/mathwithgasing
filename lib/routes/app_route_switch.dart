import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mathgasing/routes/app_route_config.dart';
import 'package:mathgasing/routes/app_route_const.dart';

class AppRouterSwitch {
  // Define appropriate values for level and materi
  static dynamic get level => level;
  
  static dynamic get materi => materi;
  
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (kDebugMode) {
      print('===> ${settings.name}');
    }

    switch (settings.name) {
      case AppRouteConstants.splashscreen:
        return AppRouter.splashScreen();
      case AppRouteConstants.loginscreen:
        return AppRouter.loginScreen();
      case AppRouteConstants.registerscreen:
        return AppRouter.registerScreen();
      case AppRouteConstants.homescreen:
        return AppRouter.homeScreen();
      case AppRouteConstants.profilescreen:
        return AppRouter.profileScreen();
      case AppRouteConstants.pretestscreen:
        return AppRouter.pretestScreen(
          level: level, // Provide appropriate value for level
          materi: materi, // Provide appropriate value for materi
        );
      case AppRouteConstants.materialscreen:
        return AppRouter.materialScreen(
          level: level, // Provide appropriate value for level
          materi: materi, // Provide appropriate value for materi
        );
      case AppRouteConstants.posttestscreen:
        return AppRouter.posttestScreen(
          level: level, // Provide appropriate value for level
          materi: materi, // Provide appropriate value for materi
        );
      default:
        return onErrorRoute();
    }
  }

  static Route<dynamic> onErrorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('Error, Route not found'),
        ),
      ),
    );
  }
}
