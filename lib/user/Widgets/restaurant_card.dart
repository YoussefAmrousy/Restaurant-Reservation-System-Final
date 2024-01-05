// ignore_for_file: must_be_immutable, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reservy/Utils/map_util.dart';
import 'package:reservy/Utils/util.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/user/Screens/user_restaurant_details.dart';

class RestaurantCard extends StatefulWidget {
  RestaurantCard(
      {super.key,
      required this.restaurant,
      required this.branch,
      required this.currentLocation});
  Restaurant restaurant;
  Branch branch;
  Position? currentLocation;

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  String? _logoPath;
  MapUtil mapUtil = MapUtil();

  @override
  void initState() {
    super.initState();
    _logoPath = widget.restaurant.logoPath;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserRestaurantDetails(
              branch: widget.branch,
              restaurant: widget.restaurant,
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
              child: _logoPath != null
                  ? Image.network(
                      _logoPath!,
                      width: 80,
                      height: 80,
                    )
                  : SizedBox(
                      width: 80,
                      height: 80,
                      child: Text('Unavailable'),
                    ),
            ),
            SizedBox(height: 3),
            Text(
              widget.branch.restaurantName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Popular with ${widget.restaurant.popularFood}',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              '${widget.restaurant.rating} ⭐',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${Util.getDistanceToBranch(widget.currentLocation!, widget.branch.latitude!, widget.branch.longitude!)} away',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
