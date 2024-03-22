import 'package:flutter/material.dart';
import 'package:mathgasing/screens/splash_screen/pages/splashscreen_page.dart';


void main()=>runApp( MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Gasing App',
      // theme: AppTheme.lightTheme,
      home: SplashScreen()
    );
  }

}

