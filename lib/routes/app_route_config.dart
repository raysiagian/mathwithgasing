import 'package:flutter/material.dart';
import 'package:mathgasing/routes/app_route_const.dart';
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/auth/registration_screen/pages/registration_page.dart';
import 'package:mathgasing/screens/main_screen/home_screen/pages/home_page.dart';
import 'package:mathgasing/screens/main_screen/profile_screen/pages/profile_page.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/pages/statistic_page.dart';
import 'package:mathgasing/screens/onboarding_screen/pages/onboarding_page.dart';
import 'package:mathgasing/screens/splash_screen/pages/splashscreen_page.dart';

class AppRouter {

  static splashScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.splashscreen),
      builder: (context) => const SplashScreen(),
    );
  }

  static onboardingScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.onboardingscreen),
      builder: (context) => const Onboarding(),
    );
  }

  static loginScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.loginscreen),
      builder: (context) => const Login(),
    );
  }

  static registerScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.loginscreen),
      builder: (context) => const Register(),
    );
  }

  static homeScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.homescreen),
      builder: (context) => const Home(),
    );
  }

  static statisticscreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.statisticscreen),
      builder: (context) => const Statistic(),
    );
  }

  static profileScreen(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouteConstants.profilescreen),
      builder: (context) => const Profile(),
    );
  }

}

