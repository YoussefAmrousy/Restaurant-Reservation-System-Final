import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String? id;
  String? userId;
  String? username;
  String? restaurant;
  DateTime? date;
  String? time;
  String? branch;
  int? guests;
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

  factory Reservation.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
        id: doc.id,
        userId: data['userId'],
        username: data['username'],
        restaurant: data['restaurant'],
        date: data['date'].toDate(),
        time: data['time'],
        branch: data['branch'],
        guests: data['guests'],
        rated: data['rated']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'restaurant': restaurant,
      'date': date,
      'time': time,
      'branch': branch,
      'guests': guests,
      'rated': rated,
    };
  }
}
