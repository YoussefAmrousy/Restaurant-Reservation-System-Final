import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String username;
  final String restaurant;
  final DateTime date;
  final String time;
  final String branch;

  Reservation(
      {required this.username,
      required this.restaurant,
      required this.date,
      required this.time,
      required this.branch});

  factory Reservation.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
        username: data['username'],
        restaurant: data['restaurant'],
        date: data['date'].toDate(),
        time: data['time'],
        branch: data['branch']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'restaurant': restaurant,
      'date': date,
      'time': time,
      'branch': branch
    };
  }
}
