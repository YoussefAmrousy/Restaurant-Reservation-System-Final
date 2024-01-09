// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetConnection {
  static bool? isInternetConnected;

  static Future<bool> checkInternetConnection() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      isInternetConnected = false;
      return false;
    }
    isInternetConnected = true;
    return true;
  }

  static showUnavailableConnectionPopup(
      BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No Internet Connection'),
        content: Text('Please check your network connection.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
