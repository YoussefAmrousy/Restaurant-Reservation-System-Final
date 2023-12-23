import 'package:flutter/material.dart';

class Reservation {
  final String username;
  final String restaurant;
  final DateTime date;
  final TimeOfDay time;
  final String branch;

  Reservation(
      {required this.username,
      required this.restaurant,
      required this.date,
      required this.time,
      required this.branch});
}
