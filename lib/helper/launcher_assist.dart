import 'package:flutter/services.dart';

class LauncherAssist {
  static const MethodChannel _channel = const MethodChannel('com.rsoft.flauncher/launcher');

  /// Gets you the current wallpaper on the user's device. This method
  /// needs the READ_EXTERNAL_STORAGE permission on Android Oreo.
  static getWallpaper() async {
    var data = await _channel.invokeMethod('getWallpaper');
    return data;
  }
}