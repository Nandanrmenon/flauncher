import 'package:flauncher/constants.dart';
import 'package:flauncher/page/home_page.dart';
import 'package:flauncher/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLauncher',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      darkTheme: themeDark(),
      home: HomePage(),
    );
  }
}
