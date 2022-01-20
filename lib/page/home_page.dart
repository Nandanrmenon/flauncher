import 'dart:typed_data';

import 'package:flauncher/helper/launcher_assist.dart';
import 'package:flauncher/page/settings_page.dart';
import 'package:flauncher/widget/toolbar.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timer_builder/timer_builder.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // static const MethodChannel _channel = const MethodChannel('com.rsoft.flauncher/launcher');
  List<Application> apps = [];
  List<String> excludeapp = [
    'com.android.traceur',
    'org.chromium.webview_shell',
    'com.rsoft.flauncher'
  ];
  List<String> fav = [
    'com.android.dialer',
    'com.google.android.apps.messaging'
  ];
  var wallpaper;

  // getWallpaper() async {
  //   var data = await _channel.invokeMethod('getWallpaper');
  //   print('hi');
  //   print(data);
  //   return data;
  // }
  @override
  void initState() {
    LauncherAssist.getWallpaper().then((imageData) {
      setState(() {
        wallpaper = imageData;
      });
    });
    // TODO: implement initState
    checkPerms();
    getApps();
    super.initState();
  }

  String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("hh:mm").format(now);
  }

  String getSystemDate() {
    var now = new DateTime.now();
    return new DateFormat("dd/MM").format(now).toString();
  }

  void getApps() async {
    apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true);
    apps.sort((a, b) => a.appName.compareTo(b.appName));
    apps = apps
        .where((element) => !excludeapp.contains(element.packageName))
        .toList();
  }

  Future checkPerms() async {
    var status = await Permission.manageExternalStorage.status;
    Permission.manageExternalStorage.request();
    if (status.isDenied) Permission.manageExternalStorage.request();
    if (status.isPermanentlyDenied) openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: GestureDetector(
          onLongPress: () => showMenu(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // body: Container(
            //   child: ListView(
            //     reverse: true,
            //     children: [],
            //   ),
            // ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return ListView(
                    reverse: true,
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                          child: Padding(
                        padding: kGlobalCardPadding,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              getSystemTime(),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              getSystemDate(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      )),
                    ],
                  );
                },
              ),
            ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () => showApps(),
            //   child: Icon(CupertinoIcons.app),
            // ),
            // bottomSheet: GestureDetector(
            //   onVerticalDragStart: (details) => showApps(),
            //   child: Container(
            //     height: 100,
            //     width: MediaQuery.of(context).size.width,
            //     child: Row(
            //       children: [],
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  void showMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return Container(
            // padding: EdgeInsets.all(10.0),
            // margin: EdgeInsets.all(10.0),
            height: 220,
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
                      leading: Icon(Icons.wallpaper_outlined),
                      title: Text('Wallpapers'),
                      onTap: () {
                        DeviceApps.openApp('com.google.android.apps.wallpaper');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text('Open System Settings'),
                      onTap: () {
                        DeviceApps.openApp('com.android.settings');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showApps() {
    final orientation = MediaQuery.of(context).orientation;
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Scaffold(
                  body: Container(
                margin: EdgeInsets.only(top: 25),
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 150.0,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text('Apps'),
                          centerTitle: true,
                        ),
                        actions: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.search))
                        ],
                      ),
                    ];
                  },
                  body: Container(
                    padding: EdgeInsets.all(8),
                    child: GridView.builder(
                      itemCount: apps.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 4 : 5),
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (context, index) {
                        Application app = apps[index];
                        print(app.packageName);
                        return InkWell(
                          onTap: () {
                            DeviceApps.openApp(app.packageName);
                          },
                          onLongPress: () =>
                              DeviceApps.openAppSettings(app.packageName),
                          child: new Card(
                            elevation: 0,
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
              )
                  // bottomNavigationBar: BottomAppBar(
                  //     child: Padding(
                  //   padding: EdgeInsets.only(
                  //       bottom: MediaQuery.of(context).viewInsets.bottom),
                  //   child: Container(
                  //     margin:
                  //         EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(.5),
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //     child: new Row(
                  //       children: [
                  //         SizedBox(
                  //           width: 5.0,
                  //         ),
                  //         Container(
                  //           padding: EdgeInsets.all(5.0),
                  //           child: ConstrainedBox(
                  //             constraints:
                  //                 BoxConstraints.tightFor(width: 50, height: 40),
                  //             child: ElevatedButton(
                  //               child: Icon(CupertinoIcons.search),
                  //               onPressed: () {},
                  //               style: ElevatedButton.styleFrom(
                  //                 shape: CircleBorder(),
                  //                 primary: kPrimaryColor,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: new TextField(
                  //             decoration: new InputDecoration.collapsed(
                  //                 hintText: 'Search',
                  //                 hintStyle: TextStyle(color: Colors.white)),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )),
                  );
            },
          );
        });
  }
}
