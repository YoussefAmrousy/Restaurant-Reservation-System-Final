// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:reservy/user/Screens/user_reservations.dart';
import 'package:reservy/user/Screens/user_restaurants_list.dart';

class UserNavigationBar extends StatefulWidget {
  UserNavigationBar({super.key, required this.selectedIndex});
  int selectedIndex;

  @override
  _UserNavigationBarState createState() => _UserNavigationBarState();
}

class _UserNavigationBarState extends State<UserNavigationBar> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    UserRestaurantsList(),
    UserReservationsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[widget.selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
            GButton(
              icon: Icons.calendar_today,
              text: 'Reservations',
            ),
          ],
          selectedIndex: widget.selectedIndex,
          onTabChange: (index) {
            setState(() {
              widget.selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
