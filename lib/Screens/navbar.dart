import 'package:flutter/material.dart';

class NavigationBarT extends StatefulWidget {
  const NavigationBarT({super.key});
  @override
  BottomNavPageState createState() => BottomNavPageState();
}

class BottomNavPageState extends State<NavigationBarT> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Browse Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
