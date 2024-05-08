import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/routes/app_route_config.dart';
import 'package:mathgasing/routes/app_route_const.dart';

class AppRouterSwitch {
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
          user: settings.arguments as User,
        );
      case AppRouteConstants.profilescreen:
        return AppRouter.profileScreen();
      case AppRouteConstants.mapunitlevelscreen:
        return AppRouter.mapunitlevelScreen(
          // Provide appropriate value for level
          materi: settings.arguments as Materi, // Provide appropriate value for materi
        );
      case AppRouteConstants.pretestscreen:
        return AppRouter.pretestScreen(
          level: settings.arguments as Level, // Provide appropriate value for level
          materi: settings.arguments as Materi,
          pretest: settings.arguments as PreTest, // Provide appropriate value for materi
          // pretest: pretest,
        );
      case AppRouteConstants.materialscreen:
        return AppRouter.materialScreen(
          level: settings.arguments as Level, // Provide appropriate value for level
          materi: settings.arguments as Materi,
          // Provide appropriate value for materi
        );
      case AppRouteConstants.posttestscreen:
        return AppRouter.posttestScreen(
          level: settings.arguments as Level, // Provide appropriate value for level
          materi: settings.arguments as Materi, // Provide appropriate value for materi
          posttest: settings.arguments as PostTest,
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
