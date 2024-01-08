import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final String tableReservation = 'Reservations';

class reservationFields {
  static final List<String> values = [
    /// Add all fields
    'id', 'userId', username, restaurant, date, time, 'branch', guests, rated
  ];
  static final int id = 'id' as int;
  static final int userId = 'userId' as int;
  static final String username = 'username';
  static final String restaurant = 'restaurant';
  static final String date = 'date';
  static final String time = 'time';
  static final int branch = 'branch' as int;
  static final String guests = 'guests';
  static final String rated = 'rated';
}

class Reservation {
  final String? id;
  final String? userId;
  final String? username;
  final String? restaurant;
  final DateTime? date;
  final String? time;
  final String? branch;
  final int? guests;
  bool? rated;

  Reservation(
      {this.id,
      this.userId,
      this.username,
      this.restaurant,
      this.date,
      this.time,
      this.branch,
      this.guests,
      this.rated = false});

  Reservation copy({
    String? id,
    String? userId,
    String? username,
    String? restaurant,
    DateTime? date,
    String? time,
    String? branch,
    int? guests,
    bool? rated,
  }) =>
      Reservation(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        username: username ?? this.username!,
        restaurant: restaurant ?? this.restaurant!,
        date: date ?? this.date,
        time: time ?? this.time!,
        branch: branch ?? this.branch!,
        guests: guests ?? this.guests!,
        rated: rated ?? this.rated!,
      );
  static Reservation fromJson(Map<String, Object?> json) => Reservation(
        id: json[reservationFields.id] as String,
        userId: json[reservationFields.userId] as String,
        username: json[reservationFields.username] as String,
        restaurant: json[reservationFields.restaurant] as String,
        date: DateTime.parse(json[reservationFields.date] as String),
        time: json[reservationFields.time] as String,
        branch: json[reservationFields.branch] as String?,
        guests: json[reservationFields.guests] as int,
        rated: json[reservationFields.rated] == 1,
      );

  factory Reservation.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
        id: data['id'],
        userId: data['userId'],
        username: data['username'],
        restaurant: data['restaurant'],
        date: data['date'].toDate(),
        time: data['time'],
        branch: data['branch'],
        guests: data['guests'],
        rated: data['rated']);
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'userId': userId,
  //     'username': username,
  //     'restaurant': restaurant,
  //     'date': date,
  //     'time': time,
  //     'branch': branch,
  //     'guests': guests,
  //     'rated': rated,
  //   };
  // }

  Map<String, Object?> toJson() => {
        reservationFields.id as String: id,
        reservationFields.userId as String: userId,
        reservationFields.username: username,
        reservationFields.restaurant: restaurant,
        reservationFields.date: date.toString(),
        reservationFields.time: time,
        reservationFields.branch as String: branch,
        reservationFields.guests: guests,
        reservationFields.rated as String: rated
      };
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Reservation {
//   final String? id;
//   final String? userId;
//   final String? username;
//   final String? restaurant;
//   final DateTime? date;
//   final String? time;
//   final String? branch;
//   final int? guests;
//   bool? rated;

//   Reservation(
//       {this.id,
//       this.userId,
//       this.username,
//       this.restaurant,
//       this.date,
//       this.time,
//       this.branch,
//       this.guests,
//       this.rated = false});

//   factory Reservation.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return Reservation(
//         id: doc.id,
//         userId: data['userId'],
//         username: data['username'],
//         restaurant: data['restaurant'],
//         date: data['date'].toDate(),
//         time: data['time'],
//         branch: data['branch'],
//         guests: data['guests'],
//         rated: data['rated']);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'username': username,
//       'restaurant': restaurant,
//       'date': date,
//       'time': time,
//       'branch': branch,
//       'guests': guests,
//       'rated': rated,
//     };
//   }
// }
