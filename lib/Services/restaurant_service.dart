import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/firebase_storage_service.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/models/user_data.dart';

class RestaurantService {
  CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('restaurants');
  List<Restaurant> restaurants = [];
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  QueryDocumentSnapshot<Object?>? restaurantDeleted;

  Future<List<Restaurant>> getAllRestaurants() async {
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

    final email = restaurant.name!.replaceAll(' ', '').toLowerCase() +
        '@reservy.com'.toLowerCase();
    restaurant.email = email;

    UserData userData = UserData(
      username: restaurant.name,
      role: 'restaurant',
      restaurant: restaurant.name,
    );

    AuthService authService = AuthService();
    authService.registerWithEmailAndPassword(email, "reservy2024", userData);

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

  Future<QueryDocumentSnapshot<Object?>?> deleteRestaurant(String name) async {
    final restaurantQuery =
        await restaurantsCollection.where('name', isEqualTo: name).get();
    if (restaurantQuery.docs.isNotEmpty) {
      restaurantDeleted = restaurantQuery.docs.first;
      await restaurantDeleted?.reference.delete();
    }
    return restaurantDeleted;
  }

  rateRestaurant(String restaurant, double ratingBarValue) async {
    var restaurantQuery =
        await restaurantsCollection.where('name', isEqualTo: restaurant).get();
    var res = Restaurant.fromSnapshot(restaurantQuery.docs.first);

    double? rating = res.rating;
    int? ratingCount = res.ratingCount;
    if (rating == 0) {
      rating = ratingBarValue;
      ratingCount = 1;
    } else {
      rating = (rating! * ratingCount! + ratingBarValue) / (ratingCount + 1);
      ratingCount++;
    }

    await restaurantQuery.docs.first.reference
        .update({'rating': ratingBarValue, 'ratingCount': ratingCount});
  }
}
