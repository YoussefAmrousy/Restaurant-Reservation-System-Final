import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';

class RestaurantCollectionUtils {
  CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('restaurants');
  List<Restaurant> restaurants = [];
  bool isLoading = false;
  Future<void> fetchRestaurants() async {
    isLoading = true;
    final querySnapshot = await restaurantsCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      restaurants = querySnapshot.docs
          .map((doc) => Restaurant.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      isLoading = false;
      return;
    }
    restaurants = [];
    return;
  }

  Future<void> deleteRestaurant(Restaurant restaurant) async {
    final restaurantQuery = await restaurantsCollection
        .where('name', isEqualTo: restaurant.name)
        .get();
    if (restaurantQuery.docs.isNotEmpty) {
      final restaurantFound = restaurantQuery.docs.first;
      restaurants.remove(restaurant);
      await restaurantFound.reference.delete();
    }
  }

  Future<Restaurant?> getRestaurantByName(String restaurantName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('name', isEqualTo: restaurantName)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return Restaurant.fromFireStore(querySnapshot.docs.first);
    }
    return null;
  }
}
