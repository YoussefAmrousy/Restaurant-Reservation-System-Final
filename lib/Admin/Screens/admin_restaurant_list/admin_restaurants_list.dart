// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservy/Admin/Screens/admin_restaurant_list/restaurant_item_widget.dart';
import 'package:reservy/Admin/Screens/restaurant_creation.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/restaurant_service.dart';
class RestaurtantsListScreen extends StatefulWidget {
  const RestaurtantsListScreen({super.key});

  @override
  _RestaurtantsListState createState() => _RestaurtantsListState();
}

class _RestaurtantsListState extends State<RestaurtantsListScreen> {
  RestaurantService restaurantService = RestaurantService();
  CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('restaurants');

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializeData() async {
    await restaurantService.getAllRestaurants();
    setState(() {});
  }

  Future<void> deleteRestaurant(BuildContext context, String name) async {
    final restaurantQuery =
        await restaurantsCollection.where('name', isEqualTo: name).get();
    if (restaurantQuery.docs.isNotEmpty) {
      final restaurantFound = restaurantQuery.docs.first;
      await restaurantFound.reference.delete();
      initializeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(236, 235, 235, 1),
        title: Text(
          'Restaurants',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushNamed(context, '/login');
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantCreationScreen(),
                ),
              );

              await restaurantService.getAllRestaurants();
              setState(() {});
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          restaurantService.restaurants.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No restaurants available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurantService.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant =
                          restaurantService.restaurants[index];
                      return RestaurantItem(
                        restaurant: restaurant,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}