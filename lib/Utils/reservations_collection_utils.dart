// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_reservation_final/models/reservation.dart';

Future<List<Reservation>> getUserReservations(String userId) async {
  try {
    final QuerySnapshot reservationQuery = await FirebaseFirestore.instance
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .get();

    return reservationQuery.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Reservation(
        username: data['username'],
        restaurant: data['restaurant'],
        date: (data['date'] as Timestamp).toDate(),
        time: data['time'],
        branch: data['branch'],
      );
    }).toList();
  } catch (e) {
    print('Error getting user reservations: $e');
    return [];
  }
}
