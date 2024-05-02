import 'package:flutter/material.dart';

class AppColors {
  static const int _primaryValue = 0xFF228DEA;
  static const int _mySecondaryValue = 0xFF6193C1;
  static const int _logoutValue = 0xFFF03A55;
  static const int _greenValue = 0xFF20A612;

  static const MaterialColor primaryColor = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFE2F2FF),
      100: Color(0xFFB6DBFF),
      200: Color(0xFF89C3FF),
      300: Color(0xFF5CAAFF),
      400: Color(0xFF349DFF),
      500: Color(_primaryValue),
      600: Color(0xFF0077E6),
      700: Color(0xFF0065C2),
      800: Color(0xFF00539E),
      900: Color(0xFF003D70),
    },
  );


 static const MaterialColor secondaryColor = MaterialColor(
    _mySecondaryValue,
    <int, Color>{
      50: Color(0xFFE7EFF7),
      100: Color(0xFFC2D7EC),
      200: Color(0xFF9DBFDF),
      300: Color(0xFF78A7D3),
      400: Color(0xFF5B96CA),
      500: Color(_mySecondaryValue),
      600: Color(0xFF4B82B3),
      700: Color(0xFF4374A6),
      800: Color(0xFF3A6599),
      900: Color(0xFF2A4980),
    },
  );

  

static const MaterialColor logoutColor = MaterialColor(
  _logoutValue,
  <int, Color>{
    500: Color(_logoutValue),
  },
);


static const MaterialColor greenColor = MaterialColor(
  _greenValue,
  <int, Color>{
    500: Color(_greenValue),
  },
);

}