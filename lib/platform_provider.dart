import 'dart:io';
import 'package:flutter/material.dart';

enum DeviceType {
  ANDROID,
  IOS,
}

class PlatformProvider with ChangeNotifier {
  DeviceType? deviceType;

  void checkPlatform() {
    deviceType = Platform.isAndroid ? DeviceType.ANDROID : DeviceType.IOS;
    notifyListeners();
  }
}