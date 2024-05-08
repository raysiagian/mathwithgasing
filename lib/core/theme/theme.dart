import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/font/font.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      background: Colors.grey,
      error: Colors.red,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
    ),
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.primaryColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      titleTextStyle: AppTextTheme.textTheme.titleLarge?.copyWith(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
    ),
    textTheme: AppTextTheme.poppinsTheme,
    fontFamily: GoogleFonts.poppins().fontFamily,
    useMaterial3: false,
  );
}

// AppBar(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//         toolbarHeight: 90,
//         title: Text(
//           'Level ${widget.level.number}',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             color: Theme.of(context).primaryColor,
//             fontWeight: FontWeight.bold
//           ),
//         ),
//         centerTitle: true,
//       ),