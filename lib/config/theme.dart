import 'package:flutter/material.dart';
import 'package:tasks_app/utils/utils.dart';

TextTheme textTheme(bool isDarkTheme) => TextTheme(
      headline1: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        color: isDarkTheme ? kContentColorDarkTheme : kContentColorLightTheme,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    );

ThemeData lightThemeData() {
  return ThemeData.light().copyWith(
    appBarTheme: appBarTheme,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(color: kContentColorLightTheme),
    textTheme: textTheme(false),
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryLightColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData() {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    textTheme: textTheme(true),
    colorScheme: ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryDarkColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
