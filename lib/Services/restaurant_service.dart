import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_reservation_final/Services/firebase_storage_service.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';

class RestaurantService {
  CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('restaurants');
  List<Restaurant> restaurants = [];
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  Future<List<Restaurant>> getRestaurants() async {
    restaurants.clear();
    final restaurantQuery = await restaurantsCollection.get();
    if (restaurantQuery.docs.isNotEmpty) {
      for (var doc in restaurantQuery.docs) {
        restaurants.add(Restaurant.fromSnapshot(doc));
      }
    }
    return restaurants;
  }

  Future<bool> addRestaurant(
      Restaurant restaurant, File logo, File menu) async {
    final restaurantQuery = await restaurantsCollection
        .where('name', isEqualTo: restaurant.name)
        .get();

    if (restaurantQuery.docs.isNotEmpty) return false;

    final logoUrl = await firebaseStorageService.uploadImage(
        imageToUpload: logo, title: restaurant.name!, type: 'logo');
    restaurant.logoPath = logoUrl;

    final menuUrl = await firebaseStorageService.uploadImage(
        imageToUpload: menu, title: restaurant.name!, type: 'menu');
    restaurant.menuPath = menuUrl;

    Map<String, dynamic> restaurantData = restaurant.toJson();

    DocumentReference docRef = await restaurantsCollection.add(restaurantData);
    return docRef.id.isNotEmpty;
  }

  Future<bool> updateRestaurant(Restaurant restaurant) async {
    try {
      final restaurantQuery = await restaurantsCollection
          .where('name', isEqualTo: restaurant.name)
          .get();

      if (restaurantQuery.docs.isEmpty) return false;

      final restaurantFound = restaurantQuery.docs.first;
      await restaurantFound.reference.update({
        'name': restaurant.name,
        'cuisine': restaurant.cuisine,
        'phone': restaurant.phone,
        'socialMedia': restaurant.socialMedia,
        'website': restaurant.website,
        'menuPath': restaurant.menuPath,
        'logoPath': restaurant.logoPath,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteRestaurant(String name) async {
    final restaurantQuery =
        await restaurantsCollection.where('name', isEqualTo: name).get();
    if (restaurantQuery.docs.isEmpty) return;
    final restaurantFound = restaurantQuery.docs.first;
    restaurants.remove(Restaurant.fromSnapshot(restaurantFound));
    await restaurantFound.reference.delete();
  }

  Future<Restaurant> getRestaurantByName(String name) async {
    final restaurantQuery =
        await restaurantsCollection.where('name', isEqualTo: name).get();
    if (restaurantQuery.docs.isEmpty) return Restaurant();
    final restaurantFound = restaurantQuery.docs.first;
    return Restaurant.fromSnapshot(restaurantFound);
  }
}
