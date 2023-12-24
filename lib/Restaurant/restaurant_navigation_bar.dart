// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:restaurant_reservation_final/Restaurant/reservations.dart';

class RestaurantNavigationBar extends StatefulWidget {
  const RestaurantNavigationBar({super.key});

  @override
  _UserNavigationBarState createState() => _UserNavigationBarState();
}

class _UserNavigationBarState extends State<RestaurantNavigationBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    ReservationsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: GNav(
          backgroundColor: Colors.white,
          tabActiveBorder: Border.all(
            color: Color(0xFFF57C00),
            width: 2.0,
          ),
          padding: EdgeInsets.all(16),
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(icon: Icons.person, text: 'Profile')
          ],
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}