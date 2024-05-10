import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mathgasing/routes/app_route_config.dart';
import 'package:mathgasing/routes/app_route_const.dart';

class AppRouterSwitch {

  static dynamic get unit => unit;
  
  static dynamic get materi => materi;
  
  static get pretest => null;

  static get posttest => null;

  
  static dynamic get user => user;

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
        return AppRouter.homeScreen(
          user: user,
        );
      case AppRouteConstants.profilescreen:
        return AppRouter.profileScreen();
      case AppRouteConstants.mapunitlevelscreen:
        return AppRouter.mapunitlevelScreen( // Provide appropriate value for unit
          materi: materi, // Provide appropriate value for materi
        );
      case AppRouteConstants.pretestscreen:
        return AppRouter.pretestScreen(
          unit: unit, // Provide appropriate value for unit
          materi: materi,
          pretest: pretest, // Provide appropriate value for materi
          // pretest: pretest,
        );
      case AppRouteConstants.materialscreen:
        return AppRouter.materialScreen(
          unit: unit, // Provide appropriate value for unit
          materi: materi,
          // Provide appropriate value for materi
        );
      case AppRouteConstants.posttestscreen:
        return AppRouter.posttestScreen(
          unit: unit, // Provide appropriate value for unit
          materi: materi, // Provide appropriate value for materi
          posttest: posttest,
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
