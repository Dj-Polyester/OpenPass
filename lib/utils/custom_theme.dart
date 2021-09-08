import 'package:flutter/material.dart';

class CustomTheme {
  static const int nightSwatchColor = 0xFFBB501D;

  static Map<String, ThemeData> themes = {
    "Light": ThemeData(
      iconTheme: const IconThemeData(
        color: Colors.black54,
      ),
      primaryColor: Colors.blue,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white70,
        selectedIconTheme: IconThemeData(color: Colors.black),
        selectedItemColor: Colors.black,
        unselectedIconTheme: IconThemeData(color: Colors.black54),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      dividerColor: Colors.black54,
      textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Colors.black),
        headline3: TextStyle(color: Colors.black),
        headline4: TextStyle(color: Colors.black),
        headline5: TextStyle(color: Colors.black),
        headline6: TextStyle(color: Colors.black),
        subtitle1: TextStyle(color: Colors.black),
        subtitle2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black54),
        bodyText2: TextStyle(color: Colors.black54),
        caption: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.black),
        overline: TextStyle(color: Colors.black),
      ),
    ),
    "Dark": ThemeData(
      primaryColor: Colors.blue,
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      dialogBackgroundColor: Colors.black,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: Colors.white70),
        unselectedItemColor: Colors.white70,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      dividerColor: Colors.white54,
      textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.white70),
        headline2: TextStyle(color: Colors.white70),
        headline3: TextStyle(color: Colors.white70),
        headline4: TextStyle(color: Colors.white70),
        headline5: TextStyle(color: Colors.white70),
        headline6: TextStyle(color: Colors.white70),
        subtitle1: TextStyle(color: Colors.white70),
        subtitle2: TextStyle(color: Colors.white70),
        bodyText1: TextStyle(color: Colors.white54),
        bodyText2: TextStyle(color: Colors.white54),
        caption: TextStyle(color: Colors.white70),
        button: TextStyle(color: Colors.white70),
        overline: TextStyle(color: Colors.white70),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white54,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            color: Colors.white30,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          color: Colors.white54,
        ),
        hintStyle: const TextStyle(
          color: Colors.white30,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white54,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white54,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
    ),
    "Night": ThemeData(
      primarySwatch: const MaterialColor(nightSwatchColor, <int, Color>{
        50: Color(nightSwatchColor),
        100: Color(nightSwatchColor),
        200: Color(nightSwatchColor),
        300: Color(nightSwatchColor),
        400: Color(nightSwatchColor),
        500: Color(nightSwatchColor),
        600: Color(nightSwatchColor),
        700: Color(nightSwatchColor),
        800: Color(nightSwatchColor),
        900: Color(nightSwatchColor),
      }),
      primaryColor: const Color(nightSwatchColor),
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      dialogBackgroundColor: Colors.black,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: Colors.white70),
        unselectedItemColor: Colors.white70,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      dividerColor: Colors.white54,
      textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.white70),
        headline2: TextStyle(color: Colors.white70),
        headline3: TextStyle(color: Colors.white70),
        headline4: TextStyle(color: Colors.white70),
        headline5: TextStyle(color: Colors.white70),
        headline6: TextStyle(color: Colors.white70),
        subtitle1: TextStyle(color: Colors.white70),
        subtitle2: TextStyle(color: Colors.white70),
        bodyText1: TextStyle(color: Colors.white54),
        bodyText2: TextStyle(color: Colors.white54),
        caption: TextStyle(color: Colors.white70),
        button: TextStyle(color: Colors.white70),
        overline: TextStyle(color: Colors.white70),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white54,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            color: Colors.white30,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          color: Colors.white54,
        ),
        hintStyle: const TextStyle(
          color: Colors.white30,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white54,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
    ),
  };
}
