import 'package:flauncher/constants.dart';
import 'package:flauncher/page/app.dart';
import 'package:flauncher/page/home_page.dart';
import 'package:flauncher/page/setup.dart';
import 'package:flauncher/theme.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.sakura;
    return MaterialApp(
      title: 'Flowch',
      debugShowCheckedModeBanner: false,
      // theme: theme(),
      // darkTheme: themeDark(),
      theme: FlexThemeData.light(
        scheme: usedScheme,
        // Use very subtly themed app bar elevation in light mode.
        appBarElevation: 0.5,
        appBarStyle: FlexAppBarStyle.surface,
        surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
        useSubThemes: true,
        blendLevel: 40,
        subThemesData: FlexSubThemesData(
          elevatedButtonRadius: 25.0,
          textButtonRadius: 25.0,
          outlinedButtonRadius: 25.0,
          cardRadius: 10.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      // Same definition for the dark theme, but using FlexThemeData.dark().
      darkTheme: FlexThemeData.dark(
        scheme: usedScheme,
        // Use stronger themed app bar elevation in dark mode.
        appBarElevation: 2,
        useSubThemes: true,
        blendLevel: 40,
        surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
        subThemesData: FlexSubThemesData(
          elevatedButtonRadius: 25.0,
          textButtonRadius: 25.0,
          outlinedButtonRadius: 25.0,
          cardRadius: 10.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),

      // Use the above dark or light theme based on active themeMode.
      themeMode: themeMode,
      home: LauncherApp(),
    );
  }
}
