import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservy/models/reservation.dart';

class ReservationsService {
  final CollectionReference reservationsCollection =
      FirebaseFirestore.instance.collection('reservations');
  List<Reservation> reservations = [];

  Future<List<Reservation>> getReservationsByRestaurant(
      String restaurant) async {
    reservations.clear();
    final reservationQuery = await reservationsCollection
        .where('restaurant', isEqualTo: restaurant)
        .get();
    if (reservationQuery.docs.isNotEmpty) {
      for (var doc in reservationQuery.docs) {
        reservations.add(Reservation.fromSnapshot(doc));
      }
    }
    return reservations;
  }

  Future<List<Reservation>> getReservationsByUserId(String userId) async {
    final reservationQuery =
        await reservationsCollection.where('userId', isEqualTo: userId).get();

    final List<Reservation> reservations = [];

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

  Future<Reservation?> getPassedReservation() async {
    try {
      DateTime date = DateTime.now();
      var querySnapshot = await reservationsCollection
          .where('date', isLessThan: date)
          .where('rated', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Reservation.fromSnapshot(querySnapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  updateReservation(Reservation reservation) {
    reservationsCollection.doc(reservation.id).update(reservation.toJson());
  }
}
