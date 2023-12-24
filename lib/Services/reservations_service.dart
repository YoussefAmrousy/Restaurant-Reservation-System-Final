import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_reservation_final/models/reservation.dart';

class ReservationsService {
  final CollectionReference reservationsCollection =
      FirebaseFirestore.instance.collection('reservations');
  List<Reservation> reservations = [];

  Future<List<Reservation>> getReservations() async {
    final reservationQuery = await reservationsCollection.get();
    if (reservationQuery.docs.isNotEmpty) {
      for (var doc in reservationQuery.docs) {
        reservations.add(Reservation.fromSnapshot(doc));
      }
    }
    return reservations;
  }

  Future<List<Reservation>> getReservationsByRestaurant(String restaurant) async {
    final reservationQuery = await reservationsCollection.where('restaurant', isEqualTo: restaurant).get();
    if (reservationQuery.docs.isNotEmpty) {
      for (var doc in reservationQuery.docs) {
        reservations.add(Reservation.fromSnapshot(doc));
      }
    }
    return reservations;
  }

  Future<List<Reservation>> getReservationsByUser(String username) async {
    final reservationQuery = await reservationsCollection.where('username', isEqualTo: username).get();
    if (reservationQuery.docs.isNotEmpty) {
      for (var doc in reservationQuery.docs) {
        reservations.add(Reservation.fromSnapshot(doc));
      }
    }
    return reservations;
  }

  Future<void> addReservation(Reservation reservation) async {
    await reservationsCollection.add(reservation.toJson());
  }

  Future<void> deleteReservation(String id) async {
    await reservationsCollection.doc(id).delete();
  }

  
}