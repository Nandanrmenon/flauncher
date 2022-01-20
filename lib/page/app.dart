import 'package:device_apps/device_apps.dart';
import 'package:flauncher/helper/launcher_assist.dart';
import 'package:flauncher/page/apps_list_page.dart';
import 'package:flauncher/page/home_page.dart';
import 'package:flauncher/page/settings_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LauncherApp extends StatefulWidget {
  const LauncherApp({Key? key}) : super(key: key);

  @override
  _LauncherAppState createState() => _LauncherAppState();
}

class _LauncherAppState extends State<LauncherApp> {
  late PageController _pageController;
  int _page = 1;
  var wallpaper;
  List<Application> apps = [];
  List<String> excludeapp = [
    'com.android.traceur',
    'org.chromium.webview_shell',
    'com.rsoft.flauncher',
    'com.google.android.apps.work.clouddpc'
  ];

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    LauncherAssist.getWallpaper().then((imageData) {
      setState(() {
        wallpaper = imageData;
      });
    });
    getApps();
    super.initState();
    _pageController = new PageController(initialPage: 1);
  }

  Future<bool> onWillPop() async {
    if (_pageController.page!.round() == _pageController.initialPage) {
      return false;
    } else {
      _pageController.animateToPage(_pageController.initialPage,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      return false;
    }
  }

  void getApps() async {
    await DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: true,
            includeSystemApps: true,
            includeAppIcons: true)
        .then((value) {
      setState(() {
        apps = value;
        apps.sort((a, b) => a.appName.compareTo(b.appName));
        apps = apps
            .where((element) => !excludeapp.contains(element.packageName))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
        useDivider: false,
        opacity: 0,
      ),
      child: WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
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
            body: PageView(
              children: [
                new SettingsPage(),
                new HomePage(),
                new AppsPage(
                  apps: apps,
                ),
              ],
              onPageChanged: onPageChanged,
              controller: _pageController,
            ),
            bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: false,
              // showSelectedLabels: false,
              // backgroundColor: Colors.black26,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'More',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.app),
                  label: 'Apps',
                ),
              ],
              currentIndex: _page,
              onTap: navigationTapped,
            ),
          ),
        ),
      ),
    );
  }
}
