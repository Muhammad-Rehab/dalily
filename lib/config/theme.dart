import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {

  static ThemeData lightTheme = ThemeData(
      primaryColor: const Color.fromRGBO(30, 81, 40, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(216, 233, 168, 1),
      textTheme:const TextTheme(
        displayLarge: TextStyle(
          fontSize: 30 ,
          fontWeight: FontWeight.bold,
            color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        displayMedium: TextStyle(
            fontSize: 28 ,
            fontWeight: FontWeight.bold,
            color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        displaySmall: TextStyle(
            fontSize: 26 ,
            fontWeight: FontWeight.bold,
          color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        titleLarge: TextStyle(
            fontSize: 24 ,
            fontWeight: FontWeight.bold,
          color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        titleMedium: TextStyle(
            fontSize: 22 ,
            fontWeight: FontWeight.bold,
          color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        titleSmall: TextStyle(
            fontSize: 20 ,
            fontWeight: FontWeight.bold,
          color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        bodyLarge: TextStyle(
            fontSize: 20 ,
          color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        bodyMedium: TextStyle(
          fontSize: 18 ,
          color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        bodySmall: TextStyle(
          fontSize: 16 ,
          color:  Color.fromRGBO(25, 26, 25, 1),
        ),
        labelSmall: TextStyle(
          fontSize: 14 ,
          color:  Color.fromRGBO(25, 26, 25, 1),
        )
      ),
      drawerTheme:const DrawerThemeData(
        backgroundColor:  Color.fromRGBO(216, 233, 168, 1),
      ),
      colorScheme: ColorScheme.fromSeed(
        background: const Color.fromRGBO(216, 233, 168, 1),
        seedColor: const Color.fromRGBO(78, 159, 61, 1),
        error: Colors.red,
        secondary: const Color.fromRGBO(78, 159, 61, 1),
        primary: const Color.fromRGBO(30, 81, 40, 1),
      ),
    );

  static ThemeData darkTheme  = ThemeData(
      primaryColor: const Color.fromRGBO(30, 81, 40, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(25, 26, 25, 1),
      textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontSize: 30 ,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              displayMedium: TextStyle(
                  fontSize: 28 ,
                  fontWeight: FontWeight.bold,
                color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              displaySmall: TextStyle(
                  fontSize: 26 ,
                  fontWeight: FontWeight.bold,
                color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              titleLarge: TextStyle(
                  fontSize: 24 ,
                  fontWeight: FontWeight.bold,
                color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              titleMedium: TextStyle(
                  fontSize: 22 ,
                  fontWeight: FontWeight.bold,
                color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              titleSmall: TextStyle(
                  fontSize: 20 ,
                  fontWeight: FontWeight.bold,
                color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              bodyLarge: TextStyle(
                fontSize: 20 ,
                  color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              bodyMedium: TextStyle(
                fontSize: 18 ,
                color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              bodySmall: TextStyle(
                fontSize: 16 ,
                color:  Color.fromRGBO(216, 233, 168, 1),
              ),
              labelSmall: TextStyle(
                fontSize: 14 ,
                color:  Color.fromRGBO(216, 233, 168, 1),
              )
          ),
      drawerTheme:const DrawerThemeData(
        backgroundColor: Color.fromRGBO(25, 26, 25, 1),
      ),
      colorScheme: ColorScheme.fromSeed(
        background: const Color.fromRGBO(25, 26, 25, 1),
        // background: const Color.fromRGBO(216, 233, 168, 1),
        seedColor: const Color.fromRGBO(78, 159, 61, 1),
        error: Colors.red,
        secondary: const Color.fromRGBO(78, 159, 61, 1),
        primary: const Color.fromRGBO(30, 81, 40, 1),
      ),
    );

}
