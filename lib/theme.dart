import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

ThemeData theme() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black12, // transparent status bar
    systemNavigationBarColor: Colors.transparent,
  ));
  return ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme:
      TextTheme(headline6: TextStyle(fontSize: 20.0, color: Colors.black)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 2.0,
      color: Colors.white.withOpacity(.5),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.transparent,
    dividerColor: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        onPrimary: Colors.black
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.black.withOpacity(.5),
      elevation: 0,
    ),
  );
}

ThemeData themeDark() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black12, // transparent status bar
    systemNavigationBarColor: Colors.transparent,
  ));
  return ThemeData(
    brightness: Brightness.dark,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme:
      TextTheme(headline6: TextStyle(fontSize: 20.0, color: Colors.white)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[900],
      foregroundColor: kPrimaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          onPrimary: Colors.black
      ),
    ),
    cardTheme: CardTheme(
        color: Colors.black.withOpacity(.5)
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 2.0,
      color: Colors.white.withOpacity(.5),
    ),
    dividerColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}