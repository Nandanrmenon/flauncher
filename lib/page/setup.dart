import 'package:flauncher/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  checkperms() async {
    var status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      Permission.manageExternalStorage.request();
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => new HomePage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              Permission.manageExternalStorage.request();
              openAppSettings();
            },
            child: Text('Request perms'),
          ),
        ],
      ),
    );
  }
}
