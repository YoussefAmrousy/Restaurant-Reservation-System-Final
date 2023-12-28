// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/Admin/Screens/restaurant_creation.dart';
import 'package:restaurant_reservation_final/Admin/Screens/admin_restaurant_details.dart';
import 'package:restaurant_reservation_final/Services/firebase_storage_service.dart';
import 'package:restaurant_reservation_final/Services/restaurant_service.dart';
import 'package:restaurant_reservation_final/Utils/util.dart';
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
  RestaurantService restaurantService = RestaurantService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  String? logoPath;
  Restaurant? deletedRestaurant;
  Util util = Util();

  Future<void> initializeData() async {
    await restaurantService.getAllRestaurants();
  }

  Future<void> deleteRestaurant(String name) async {
    final restaurantDeleted = await restaurantService.deleteRestaurant(name);
    deletedRestaurant =
        Restaurant.fromMap(restaurantDeleted!.data() as Map<String, dynamic>);
    initializeData();
  }

  Future<void> getLogoPath() async {
    logoPath =
        await firebaseStorageService.getImageUrl(widget.restaurant.name!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getLogoPath(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (logoPath != null) {
            return buildCard();
          } else {
            return CircularProgressIndicator();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildCard() {
    return Dismissible(
      key: Key(widget.restaurant.name!),
      onDismissed: (direction) {
        deleteRestaurant(widget.restaurant.name!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restaurant deleted successfully'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                if (deletedRestaurant != null) {
                  restaurantsCollection.add(deletedRestaurant!.toJson());
                  deletedRestaurant = null;
                  initializeData();
                  setState(() {});
                }
              },
            ),
          ),
        );
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
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: Image.network(logoPath!).image,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          util.capitalize(widget.restaurant.cuisine ?? ''),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
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
                      await restaurantService.getAllRestaurants();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
