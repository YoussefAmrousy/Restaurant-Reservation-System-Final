// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/models/branch.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';
import 'package:restaurant_reservation_final/user/Screens/restaurant_details.dart';

class RestaurantsListRow extends StatefulWidget {
  final String title;
  final String? cuisine;
  final List<Branch> branches;
  final List<Restaurant> restaurants;

  RestaurantsListRow({
    super.key,
    required this.title,
    this.cuisine,
    required this.branches,
    required this.restaurants,
  });

  @override
  _RestaurantsListRowState createState() => _RestaurantsListRowState();
}

class _RestaurantsListRowState extends State<RestaurantsListRow> {
  Restaurant? _restaurantFilter;
  String? _logoPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.branches.length,
            itemBuilder: (context, index) {
              var branch = widget.branches[index];
              _restaurantFilter = widget.restaurants.firstWhere(
                (restaurant) => restaurant.name == branch.restaurantName,
                orElse: () => Restaurant(),
              );
              _logoPath = _restaurantFilter!.logoPath;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservyWidget(
                        branch: branch,
                        restaurant: _restaurantFilter!,
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
                        branch.restaurantName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_restaurantFilter?.rating} ⭐',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '3.5 km away',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
