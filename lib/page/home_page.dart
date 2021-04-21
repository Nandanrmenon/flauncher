import 'dart:typed_data';

import 'package:flauncher/helper/launcher_assist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

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
  var wallpaper;

  // getWallpaper() async {
  //   var data = await _channel.invokeMethod('getWallpaper');
  //   print('hi');
  //   print(data);
  //   return data;
  // }
  @override
  void initState() {
    // TODO: implement initState

    getApps();
    LauncherAssist.getWallpaper().then((imageData) {
      setState(() {
        wallpaper = imageData;
      });
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            // image:MemoryImage(wallpaper)??,
            // image: AssetImage("res/wallpaper.jpg"),
            image: MemoryImage(wallpaper),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              padding: EdgeInsets.all(30.0),
              // height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(30.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Hello User',
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () => showApps(),
            child: Icon(CupertinoIcons.rectangle_grid_2x2),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.phone),
                      Text('Phone'),
                    ],
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.bubble_left_bubble_right),
                      Text('Messages'),
                    ],
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.camera),
                      Text('Camera'),
                    ],
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.globe),
                      Text('Web'),
                    ],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showApps() {
    final orientation = MediaQuery.of(context).orientation;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Scaffold(
              backgroundColor: Colors.white60.withOpacity(.1),
              body: Container(
                padding: EdgeInsets.all(8),
                child: GridView.builder(
                    itemCount: apps.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 4 : 5),
                    itemBuilder: (context, index) {
                      Application app = apps[index];
                      return InkWell(
                        onTap: () {
                          DeviceApps.openApp(app.packageName);
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
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
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              appBar: AppBar(
                toolbarHeight: 100,
                backgroundColor: Colors.transparent,
                // leading: IconButton(
                //   icon: Icon(
                //     CupertinoIcons.chevron_down,
                //     color: Colors.white,
                //   ),
                //   onPressed: () => Navigator.pop(context),
                // ),
                leading: Container(),
                title: IconButton(
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                centerTitle: true,
              ),
              bottomNavigationBar: BottomAppBar(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: new Row(
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: 50, height: 40),
                              child: ElevatedButton(
                                child: Icon(CupertinoIcons.search),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: new TextField(
                              decoration: new InputDecoration.collapsed(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }
}
