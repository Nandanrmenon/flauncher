import 'package:device_apps/device_apps.dart';
import 'package:flauncher/constants.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppsPage extends StatefulWidget {
  final List<Application> apps;
  const AppsPage({Key? key, required this.apps}) : super(key: key);

  @override
  _AppsPageState createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  List<String> fav = [
    'com.android.dialer',
    'com.google.android.apps.messaging'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      // backgroundColor: FlexColor.sakuraDarkPrimary.withOpacity(0.5),
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
                    'Hello User',
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
          body: Container(
            child: GridView.builder(
              itemCount: widget.apps.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 4 : 5),
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 80),
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                Application app = widget.apps[index];
                print(app.packageName);
                return InkWell(
                  onTap: () {
                    DeviceApps.openApp(app.packageName);
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  // onLongPress: () => DeviceApps.openAppSettings(app.packageName),
                  onLongPress: () => showAppMenu(app),
                  child: new Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 50,
                          child: app is ApplicationWithIcon
                              ? Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Image.memory(
                                    app.icon,
                                    width: 50,
                                    height: 50.0,
                                  ),
                                )
                              : Icon(CupertinoIcons.app),
                        ),
                        Text(
                          app.appName,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.search),
      ),
    );
  }

  showAppMenu(Application app) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return Container(
            height: 150,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12),
              child: Column(
                children: [
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5.0)),
                    width: 50.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('App Info'),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () => DeviceApps.openAppSettings(app.packageName),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
