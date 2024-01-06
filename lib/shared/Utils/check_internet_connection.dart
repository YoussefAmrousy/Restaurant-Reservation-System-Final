// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class CheckInternetConnection {
  static Future<bool> checkInternetAndShowPopup(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
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
      return false;
    } else {
      return true;
    }
  }
}