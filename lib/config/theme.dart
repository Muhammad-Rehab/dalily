import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {

  static ThemeData lightTheme = ThemeData(
      primaryColor: const Color.fromRGBO(30, 81, 40, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(216, 233, 168, 1),
      drawerTheme:const DrawerThemeData(
        backgroundColor:  Color.fromRGBO(216, 233, 168, 1),
      ),
      colorScheme: ColorScheme.fromSeed(
        background: const Color.fromRGBO(216, 233, 168, 1),
        seedColor: const Color.fromRGBO(78, 159, 61, 1),
        // define it to title text color
        surface: const Color.fromRGBO(216, 233, 168, 1),
        error: Colors.red,
        secondary: const Color.fromRGBO(78, 159, 61, 1),
        primary: const Color.fromRGBO(30, 81, 40, 1),
      ),
    );

  static ThemeData darkTheme  = ThemeData(
      primaryColor: const Color.fromRGBO(30, 81, 40, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(25, 26, 25, 1),
      drawerTheme:const DrawerThemeData(
        backgroundColor: Color.fromRGBO(25, 26, 25, 1),
      ),
      colorScheme: ColorScheme.fromSeed(
        background: const Color.fromRGBO(25, 26, 25, 1),
        seedColor: const Color.fromRGBO(78, 159, 61, 1),
        error: Colors.red,
        // define it to title text color
        surface: const Color.fromRGBO(216, 233, 168, 1),
        secondary: const Color.fromRGBO(78, 159, 61, 1),
        primary: const Color.fromRGBO(30, 81, 40, 1),
      ),
    );

}
