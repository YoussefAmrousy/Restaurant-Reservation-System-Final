// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/user/Widgets/restaurant_card.dart';

class RestaurantsListRow extends StatefulWidget {
  final String title;
  final List<Branch> branches;
  final List<Restaurant> restaurants;
  final Position currentLocation;

  RestaurantsListRow({
    super.key,
    required this.title,
    required this.branches,
    required this.restaurants,
    required this.currentLocation,
  });

  @override
  _RestaurantsListRowState createState() => _RestaurantsListRowState();
}

class _RestaurantsListRowState extends State<RestaurantsListRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
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
          height: 178,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.branches.length,
            itemBuilder: (context, index) {
              final branch = widget.branches[index];
              var restaurantFilter = widget.restaurants.firstWhere(
                (restaurant) => restaurant.name == branch.restaurantName,
                orElse: () => Restaurant(),
              );

              return RestaurantCard(
                  restaurant: restaurantFilter, branch: branch, currentLocation: widget.currentLocation);
            },
          ),
        ),
      ],
    );
  }
}
