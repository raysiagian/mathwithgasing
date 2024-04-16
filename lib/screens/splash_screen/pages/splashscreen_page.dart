import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/screens/auth/login_screen/pages/login_page.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/pages/home_wrapper.dart';
import 'package:mathgasing/screens/onboarding_screen/pages/onboarding_page.dart';
import 'package:mathgasing/screens/splash_screen/widget/splashscreen_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      checkFirstTimeUser();
    });
  }

  Future<void> checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('firstTime') ?? true;
    bool isLoggedIn = prefs.getString('token') != null;

    if (isFirstTime) {
      // Jika pengguna baru pertama kali menggunakan aplikasi
      prefs.setBool('firstTime', false); // Tandai bahwa aplikasi sudah pernah dibuka sebelumnya

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    } else {
      // Jika pengguna bukan baru pertama kali menggunakan aplikasi
      if (isLoggedIn) {
        // Jika pengguna sudah login sebelumnya
        checkToken();
      } else {
        // Jika pengguna belum login sebelumnya
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }
  }

  Future<void> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Jika token tersedia, lakukan pengecekan validitas token
      try {
        final response = await http.get(
          Uri.parse('http://127.0.0.1:8000/api/profile'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // Jika token valid, arahkan pengguna ke halaman utama
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeWrapper()),
          );
        } else {
          // Jika token tidak valid, arahkan pengguna ke halaman login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      } catch (e) {
        // Tangani kesalahan jaringan atau kesalahan lainnya
        print('Error: $e');
        // Jika terjadi kesalahan, arahkan pengguna ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      // Jika token tidak tersedia, arahkan pengguna ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SplashScreenWidget(),
      ),
    );
  }
}
