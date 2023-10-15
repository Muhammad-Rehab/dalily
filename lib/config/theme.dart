import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static bool isArabic = true;

  static TextStyle lightTextStyle = isArabic
      ? GoogleFonts.tajawal().copyWith(color: const Color.fromRGBO(25, 26, 25, 1))
      : GoogleFonts.lato().copyWith(color: const Color.fromRGBO(25, 26, 25, 1));
  static TextStyle darkTextStyle = isArabic
      ? GoogleFonts.tajawal().copyWith(color: const Color.fromRGBO(216, 233, 168, 1))
      : GoogleFonts.lato().copyWith(color: const Color.fromRGBO(216, 233, 168, 1));

  static ThemeData lightTheme = ThemeData(
      primaryColor: const Color.fromRGBO(30, 81, 40, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(216, 233, 168, 1),
      textTheme: TextTheme(
        displayLarge: lightTextStyle.copyWith(
          fontSize: 30 ,
          fontWeight: FontWeight.bold
        ),
        displayMedium: lightTextStyle.copyWith(
            fontSize: 28 ,
            fontWeight: FontWeight.bold
        ),
        displaySmall: lightTextStyle.copyWith(
            fontSize: 26 ,
            fontWeight: FontWeight.bold
        ),
        titleLarge: lightTextStyle.copyWith(
            fontSize: 24 ,
            fontWeight: FontWeight.bold
        ),
        titleMedium: lightTextStyle.copyWith(
            fontSize: 22 ,
            fontWeight: FontWeight.bold
        ),
        titleSmall: lightTextStyle.copyWith(
            fontSize: 20 ,
            fontWeight: FontWeight.bold
        ),
        bodyLarge: lightTextStyle.copyWith(
            fontSize: 20 ,
        ),
        bodyMedium: lightTextStyle.copyWith(
          fontSize: 18 ,
        ),
        bodySmall: lightTextStyle.copyWith(
          fontSize: 16 ,
        ),
        labelSmall: lightTextStyle.copyWith(
          fontSize: 14 ,
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
      textTheme: TextTheme(
              displayLarge: darkTextStyle.copyWith(
                  fontSize: 30 ,
                  fontWeight: FontWeight.bold
              ),
              displayMedium: darkTextStyle.copyWith(
                  fontSize: 28 ,
                  fontWeight: FontWeight.bold
              ),
              displaySmall: darkTextStyle.copyWith(
                  fontSize: 26 ,
                  fontWeight: FontWeight.bold
              ),
              titleLarge: darkTextStyle.copyWith(
                  fontSize: 24 ,
                  fontWeight: FontWeight.bold
              ),
              titleMedium: darkTextStyle.copyWith(
                  fontSize: 22 ,
                  fontWeight: FontWeight.bold
              ),
              titleSmall: darkTextStyle.copyWith(
                  fontSize: 20 ,
                  fontWeight: FontWeight.bold
              ),
              bodyLarge: darkTextStyle.copyWith(
                fontSize: 20 ,
              ),
              bodyMedium: darkTextStyle.copyWith(
                fontSize: 18 ,
              ),
              bodySmall: darkTextStyle.copyWith(
                fontSize: 16 ,
              ),
              labelSmall: darkTextStyle.copyWith(
                fontSize: 14 ,
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
