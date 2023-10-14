import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static bool isArabic = false;

  static TextStyle lightTextStyle = const TextStyle(color: Color.fromRGBO(25, 26, 25, 1));
  static TextStyle darkTextStyle = const TextStyle(color:  Color.fromRGBO(216, 233, 168, 1));

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: const Color.fromRGBO(30, 81, 40, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(216, 233, 168, 1),
      textTheme: isArabic
          ? GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme).copyWith(
        displayLarge: lightTextStyle,
        displayMedium: lightTextStyle,
        displaySmall: lightTextStyle,
        titleLarge: lightTextStyle,
        titleMedium: lightTextStyle,
        titleSmall: lightTextStyle,
        bodyLarge: lightTextStyle,
        bodyMedium: lightTextStyle,
        bodySmall: lightTextStyle,
      )
          : GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).copyWith(
        displayLarge: lightTextStyle,
        displayMedium: lightTextStyle,
        displaySmall: lightTextStyle,
        titleLarge: lightTextStyle,
        titleMedium: lightTextStyle,
        titleSmall: lightTextStyle,
        bodyLarge: lightTextStyle,
        bodyMedium: lightTextStyle,
        bodySmall: lightTextStyle,
      ),
      colorScheme: ColorScheme.fromSeed(
        background: const Color.fromRGBO(216, 233, 168, 1),
        seedColor: const Color.fromRGBO(78, 159, 61, 1),
        error: Colors.red,
        secondary: const Color.fromRGBO(78, 159, 61, 1),
        primary: const Color.fromRGBO(30, 81, 40, 1),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      primaryColor: const Color.fromRGBO(30, 81, 40, 1),
      scaffoldBackgroundColor: const  Color.fromRGBO(25, 26, 25, 1),
      textTheme: isArabic
          ? GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme).copyWith(
        displayLarge: darkTextStyle,
        displayMedium: darkTextStyle,
        displaySmall: darkTextStyle,
        titleLarge: darkTextStyle,
        titleMedium: darkTextStyle,
        titleSmall: darkTextStyle,
        bodyLarge: darkTextStyle,
        bodyMedium: darkTextStyle,
        bodySmall: darkTextStyle,
      )
          : GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).copyWith(
        displayLarge: darkTextStyle,
        displayMedium: darkTextStyle,
        displaySmall: darkTextStyle,
        titleLarge: darkTextStyle,
        titleMedium: darkTextStyle,
        titleSmall: darkTextStyle,
        bodyLarge: darkTextStyle,
        bodyMedium: darkTextStyle,
        bodySmall: darkTextStyle,
      ),
      colorScheme: ColorScheme.fromSeed(
        background: const  Color.fromRGBO(25, 26, 25, 1),
        // background: const Color.fromRGBO(216, 233, 168, 1),
        seedColor: const Color.fromRGBO(78, 159, 61, 1),
        error: Colors.red,
        secondary: const Color.fromRGBO(78, 159, 61, 1),
        primary: const Color.fromRGBO(30, 81, 40, 1),
      ),
    );
  }
}
