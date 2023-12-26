// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_reservation_final/Services/auth_service.dart';
import 'package:restaurant_reservation_final/Services/firebase_storage_service.dart';
import 'package:restaurant_reservation_final/Services/restaurant_service.dart';
import 'package:restaurant_reservation_final/models/branch.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';
import 'package:restaurant_reservation_final/shared/Widgets/restaurant_provider.dart';
import 'package:restaurant_reservation_final/user/Screens/restaurant_details.dart';

class RestaurantsListRow extends StatefulWidget {
  RestaurantsListRow(
      {super.key, required this.title, this.cuisine, required this.branches});
  String title;
  String? cuisine;
  List<Branch> branches;

  @override
  _RestaurantsListRowState createState() => _RestaurantsListRowState();
}

class _RestaurantsListRowState extends State<RestaurantsListRow> {
  RestaurantService restaurantService = RestaurantService();
  AuthService authService = AuthService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  Restaurant? restaurantFilter;
  String? logoPath;

  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantProvider>(context, listen: false).fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    List<Restaurant> restaurants =
        Provider.of<RestaurantProvider>(context).restaurants;
    print(restaurants);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.branches.length,
          itemBuilder: (context, index) {
            var branch = widget.branches[index];
            restaurantFilter = restaurants.firstWhere(
              (restaurant) {
                return restaurant.name == branch.restaurantName;
              },
            );
            logoPath = restaurantFilter!.logoPath;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservyWidget(
                      branch: branch,
                      restaurant: restaurantFilter!,
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
                      child: logoPath != null
                          ? Image.network(
                              logoPath!,
                              width: 80,
                              height: 80,
                            )
                          : SizedBox(
                              width: 80,
                              height: 80,
                              child: Text('Unavailable'),
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
    ]);
  }
}
