// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, iterable_contains_unrelated_type, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/Services/firebase_storage_service.dart';
import 'package:restaurant_reservation_final/Utils/branch_collection_utils.dart';
import 'package:restaurant_reservation_final/Utils/restaurant_collection_utils.dart';
import 'package:restaurant_reservation_final/Screens/auth_service.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';
import 'package:restaurant_reservation_final/user/restaurant_details.dart';

class UserRestaurantsList extends StatefulWidget {
  const UserRestaurantsList({super.key});

  @override
  _UserRestaurantsListState createState() => _UserRestaurantsListState();
}

class _UserRestaurantsListState extends State<UserRestaurantsList> {
  BranchCollectionUtils branchCollectionUtils = BranchCollectionUtils();
  RestaurantCollectionUtils restaurantCollectionUtils =
      RestaurantCollectionUtils();
  CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('restaurants');
  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  AuthService authService = AuthService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    await branchCollectionUtils.fetchBranches(null);
    await restaurantCollectionUtils.fetchRestaurants();
    setState(() {});
  }

  Future<void> getRestaurantByName(String restaurantName) async {
    var restaurant =
        await restaurantCollectionUtils.getRestaurantByName(restaurantName);
    this.restaurant = restaurant;
  }

  Restaurant? restaurant;

  @override
  Widget build(BuildContext context) {
    fetchData();
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 235, 235, 1),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Reservy',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await authService.signOut();
                    Navigator.pushNamed(context, '/login');
                  }),
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromRGBO(236, 235, 235, 0),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/restaurants');
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFFe7af2f),
                  width: 2,
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "I'm looking for..",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 8),
            branchCollectionUtils.branches.isEmpty ||
                    restaurantCollectionUtils.restaurants.isEmpty
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
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nearby Restaurants',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: branchCollectionUtils.branches.length,
                  itemBuilder: (context, index) {
                    var branch = branchCollectionUtils.branches[index];
                    var logo = File(firebaseStorageService
                        .getImageUrl(branch.restaurantName) as String);
                    getRestaurantByName(branch.restaurantName);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservyWidget(
                              branch: branch,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFe7af2f),
                                  width: 2,
                                ),
                              ),
                              child: Image.file(
                                logo,
                                width: 80,
                                height: 80,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              branch.restaurantName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
