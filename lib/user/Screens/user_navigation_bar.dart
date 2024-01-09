// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:reservy/shared/Utils/check_internet_connection.dart';
import 'package:reservy/user/Screens/user_reservations.dart';
import 'package:reservy/user/Screens/user_restaurants_list.dart';

class UserNavigationBar extends StatefulWidget {
  UserNavigationBar({super.key, required this.selectedIndex});
  int selectedIndex;

  @override
  _UserNavigationBarState createState() => _UserNavigationBarState();
}

class _UserNavigationBarState extends State<UserNavigationBar> {
  late PageController pageController;
  bool? isInternetConnected;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.selectedIndex);
    init();
  }

  Future<void> checkInternetConnection() async {
    isInternetConnected = await InternetConnection.checkInternetConnection();
  }

  Future<void> init() async {
    await checkInternetConnection();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
        },
        children: [
          UserRestaurantsList(),
          UserReservationsWidget(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: GNav(
          backgroundColor: Theme.of(context).backgroundColor,
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
            if (isInternetConnected == false && index == 0) {
              return;
            }
            setState(
              () {
                widget.selectedIndex = index;
              },
            );
            if (isInternetConnected == true) {
              pageController.animateToPage(
                widget.selectedIndex,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          },
        ),
      ),
    );
  }
}