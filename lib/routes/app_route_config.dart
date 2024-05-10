import 'package:flutter/material.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/routes/app_route_const.dart';
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/auth/registration_screen/pages/registration_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_screen/pages/material_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/posttest_level_screen/pages/posttest_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/pages/pretest_level_page.dart';
import 'package:mathgasing/screens/main_screen/home_screen/pages/home_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/pages/map_unit_level.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/pages/profile_page.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/pages/statistic_page.dart';
import 'package:mathgasing/screens/onboarding_screen/pages/onboarding_page.dart';
import 'package:mathgasing/screens/splash_screen/pages/splashscreen_page.dart';

class AppRouter {

  static Route<dynamic>? splashScreen(){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.splashscreen),
      builder: (context) => SplashScreen(),
    );
  }

  static Route<dynamic>? onboardingScreen(){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.onboardingscreen),
      builder: (context) => Onboarding(),
    );
  }

  static Route<dynamic>? loginScreen(){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.loginscreen),
      builder: (context) => Login(),
    );
  }

  static Route<dynamic>? registerScreen(){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.registerscreen),
      builder: (context) => Register(),
    );
  }

  static Route<dynamic>? homeScreen({required User user}){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.homescreen),
      builder: (context) => Home(authToken: 'authToken',),
    );
  }

  static Route<dynamic>? statisticscreen(){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.statisticscreen),
      builder: (context) => Statistic(),
    );
  }

  static Route<dynamic>? profileScreen(){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.profilescreen),
      builder: (context) => Profile(),
    );
  }

  static Route<dynamic>? mapunitlevelScreen({required Materi materi}){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.mapunitlevelscreen), 
      builder: (context) => MapUnitLevel(materi: materi),
    );
  }

  static Route<dynamic>? pretestScreen({required Unit unit, required Materi materi, required PreTest pretest, int? score_pretest}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.pretestscreen),
      builder: (context) => PreTestLevel(unit: unit, materi: materi, pretest:pretest ,score_pretest: score_pretest),
    );
  }

  static Route<dynamic>? materialScreen({required Materi materi, required Unit unit,}){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.materialscreen),
      builder: (context) => MaterialLevel(materi: materi, unit: unit),
    );
  }

  static Route<dynamic>? posttestScreen({required Materi materi, required Unit unit,required PostTest posttest, int? score_posttest}){
    return MaterialPageRoute(
      settings: RouteSettings(name: AppRouteConstants.posttestscreen),
      builder: (context) => PostTestLevel(materi: materi, unit: unit, posttest: posttest, score_posttest: score_posttest,),
    );
  }
}