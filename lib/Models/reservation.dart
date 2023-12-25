import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String userId;
  final String username;
  final String restaurant;
  final DateTime date;
  final String time;
  final String branch;
  final int guests;

  Reservation(
      {required this.userId,
      required this.username,
      required this.restaurant,
      required this.date,
      required this.time,
      required this.branch,
      required this.guests});

  factory Reservation.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
        userId: data['userId'],
        username: data['username'],
        restaurant: data['restaurant'],
        date: data['date'].toDate(),
        time: data['time'],
        branch: data['branch'],
        guests: data['guests']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'restaurant': restaurant,
      'date': date,
      'time': time,
      'branch': branch,
      'guests': guests
    };
  }
}
