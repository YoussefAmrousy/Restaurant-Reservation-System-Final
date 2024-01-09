// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white, opacity: 0.8),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
      //headline6: TextStyle(color: Colors.white),
     
    ),
    colorScheme: ColorScheme.dark().copyWith(
      background: Colors.grey.shade900,
      primary: Colors.black,
      secondary: Colors.white,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
  );
}
