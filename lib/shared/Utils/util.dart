// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Util {
  static String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  static String getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Janurary';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  static String getDistanceToBranch(
      Position currentLocation, double branchLatitdue, double branchLongitude) {
    double distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      branchLatitdue,
      branchLongitude,
    );
    if (distance < 1000) {
      return '${distance.round()} m';
    }
    distance = distance / 1000;
    return '${distance.round()} km';
  }

  static IconData getSocialMediaIcon(String socialMedia) {
    if (socialMedia.contains('facebook.com')) {
      return FontAwesomeIcons.facebook;
    } else if (socialMedia.contains('twitter.com') ||
        socialMedia.contains('x.com')) {
      return FontAwesomeIcons.twitter;
    } else if (socialMedia.contains('instagram.com')) {
      return FontAwesomeIcons.instagram;
    } else {
      return FontAwesomeIcons.globe;
    }
  }
}
