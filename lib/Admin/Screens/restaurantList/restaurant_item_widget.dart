// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/Admin/Screens/restaurant_creation.dart';
import 'package:restaurant_reservation_final/Admin/Screens/restaurant_details.dart';
import 'package:restaurant_reservation_final/Services/firebase_storage_service.dart';
import 'package:restaurant_reservation_final/Utils/restaurant_collection_utils.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';

class RestaurantItem extends StatefulWidget {
  RestaurantItem({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  _RestaurantItemState createState() => _RestaurantItemState();
}

class _RestaurantItemState extends State<RestaurantItem> {
  CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('restaurants');
  RestaurantCollectionUtils restaurantCollectionUtils =
      RestaurantCollectionUtils();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  String? logoPath;

  Future<void> initializeData() async {
    await restaurantCollectionUtils.fetchRestaurants();
  }

  Future<void> deleteRestaurant(String name) async {
    final restaurantQuery =
        await restaurantsCollection.where('name', isEqualTo: name).get();
    if (restaurantQuery.docs.isNotEmpty) {
      final restaurantFound = restaurantQuery.docs.first;
      await restaurantFound.reference.delete();
      initializeData();
    }
  }

  Future<void> getLogoPath() async {
    logoPath = await firebaseStorageService.getImageUrl(widget.restaurant.name);
  }

  @override
  Widget build(BuildContext context) {
    getLogoPath();
    return Dismissible(
      key: Key(widget.restaurant.name),
      onDismissed: (direction) {
        deleteRestaurant(widget.restaurant.name);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailsScreen(
                restaurant: widget.restaurant,
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: Image.network(logoPath!).image,
            ),
            title: Text(
              widget.restaurant.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantCreationScreen(
                      restaurant: widget.restaurant,
                    ),
                  ),
                );
                await restaurantCollectionUtils.fetchRestaurants();
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
