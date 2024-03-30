import 'package:flutter/material.dart';
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/routes/app_route_const.dart';
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/auth/registration_screen/pages/registration_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_page.dart/pages/material_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/posttest_level_screen/pages/posttest_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/pages/pretest_level_page.dart';
import 'package:mathgasing/screens/main_screen/home_screen/pages/home_page.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/pages/profile_page.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/pages/statistic_page.dart';
import 'package:mathgasing/screens/onboarding_screen/pages/onboarding_page.dart';
import 'package:mathgasing/screens/splash_screen/pages/splashscreen_page.dart';

class AppRouter {

  static Route<dynamic>? splashScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.splashscreen),
      builder: (context) => const SplashScreen(),
    );
  }

  static Route<dynamic>? onboardingScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.onboardingscreen),
      builder: (context) => const Onboarding(),
    );
  }

  static Route<dynamic>? loginScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.loginscreen),
      builder: (context) => const Login(),
    );
  }

  static Route<dynamic>? registerScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.registerscreen),
      builder: (context) => const Register(),
    );
  }

  static Route<dynamic>? homeScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.homescreen),
      builder: (context) => const Home(),
    );
  }

  static Route<dynamic>? statisticscreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.statisticscreen),
      builder: (context) => const Statistic(),
    );
  }

  static Route<dynamic>? profileScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.profilescreen),
      builder: (context) => const Profile(),
    );
  }

  static Route<dynamic>? pretestScreen({required Level level, required Materi materi}){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.pretestscreen),
      builder: (context) => PreTestLevel(level: level, materi: materi),
    );
  }
  
  static Route<dynamic>? materialScreen({required Materi materi, required Level level}){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.materialscreen),
      builder: (context) => MaterialLevel(materi: materi, level: level),
    );
  }

  static Route<dynamic>? posttestScreen({required Materi materi, required Level level}){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.posttestscreen),
      builder: (context) => PostTestLevel(materi: materi, level: level),
    );
  }

}
