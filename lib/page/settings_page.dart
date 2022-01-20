import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return Scaffold(
      // backgroundColor: Colors.black26,
      backgroundColor: darkModeOn
          ? FlexColor.sakuraLightPrimary.withOpacity(0.5)
          : FlexColor.sakuraDarkPrimary.withOpacity(0.5),
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                pinned: true,
                elevation: 0,
                backgroundColor: darkModeOn
                    ? FlexColor.sakuraLightPrimary.withOpacity(0.5)
                    : FlexColor.sakuraDarkPrimary.withOpacity(0.5),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Quick Settings',
                    style: TextStyle(
                        color: darkModeOn ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                  // centerTitle: true,
                  titlePadding: EdgeInsets.only(left: 30, bottom: 15),
                ),
              ),
            ];
          },
          body: ListView(
            children: [],
          ),
        ),
      ),
    );
  }
}
