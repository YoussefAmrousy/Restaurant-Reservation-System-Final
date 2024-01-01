// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/branch_service.dart';
import 'package:reservy/Services/firebase_storage_service.dart';
import 'package:reservy/Services/restaurant_service.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/shared/Widgets/not_available.dart';
import 'package:reservy/user/Widgets/restaurants_list_row.dart';

class UserRestaurantsList extends StatefulWidget {
  UserRestaurantsList({super.key, required this.currentUserPosition});
  Position currentUserPosition;

  @override
  _UserRestaurantsListState createState() => _UserRestaurantsListState();
}

class _UserRestaurantsListState extends State<UserRestaurantsList> {
  BranchService branchService = BranchService();
  RestaurantService restaurantService = RestaurantService();
  AuthService authService = AuthService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  Restaurant? restaurant;
  String? logoPath;
  TextEditingController searchController = TextEditingController();
  List<Restaurant> italian = [];
  List<Restaurant> japanese = [];
  List<Restaurant> american = [];
  List<Branch> italianBranches = [];
  List<Branch> japaneseBranches = [];
  List<Branch> americanBranches = [];
  late Position _currentLocation;

  @override
  void initState() {
    super.initState();
    getBranches();
    getAllRestaurants();
    getNearbyRestaurants();
  }

  Future<void> getBranches() async {
    var branches = await branchService.getAllBranches();
    setState(() {
      branchService.branches = branches;
      italianBranches = branches.where((e) => e.cuisine == 'italian').toList();
      japaneseBranches =
          branches.where((e) => e.cuisine == 'japanese').toList();
      americanBranches =
          branches.where((e) => e.cuisine == 'american').toList();
    });
  }

  Future<void> getAllRestaurants() async {
    var restaurants = await restaurantService.getAllRestaurants();
    setState(() {
      restaurantService.restaurants = restaurants;
      italian = restaurants.where((e) => e.cuisine == 'italian').toList();
      american = restaurants.where((e) => e.cuisine == 'american').toList();
      japanese = restaurants.where((e) => e.cuisine == 'japanese').toList();
    });
  }

  Future<void> getNearbyRestaurants() async {
    const double maxDistance = 99999999999999;
    double distanceInKm = 0;

    final List<Branch> nearbyBranches = branchService.branches.where((branch) {
      distanceInKm = Geolocator.distanceBetween(
            _currentLocation.latitude,
            _currentLocation.longitude,
            branch.latitude!,
            branch.longitude!,
          ) /
          1000;

      return distanceInKm <= maxDistance;
    }).toList();
    print(_currentLocation.latitude);

    // setState(() {
    //   branchService.branches = nearbyBranches;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    if (mounted) {
                      Navigator.pushNamed(context, '/login');
                    }
                  },
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromRGBO(236, 235, 235, 0),
                elevation: 0,
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
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) getBranches();
                      branchService.branches = branchService.branches
                          .where((branch) => branch.restaurantName
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "I'm looking for..",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 8),
              branchService.branches.isEmpty
                  ? NotAvailable(message: 'restaurants')
                  : Column(
                      children: [
                        RestaurantsListRow(
                          title: 'Neraby Restaurants',
                          branches: branchService.branches,
                          restaurants: restaurantService.restaurants,
                        ),
                        RestaurantsListRow(
                          title: 'Italian Restaurants',
                          branches: italianBranches,
                          restaurants: italian,
                        ),
                        RestaurantsListRow(
                            title: 'Japanese Restaurants',
                            branches: japaneseBranches,
                            restaurants: japanese),
                        RestaurantsListRow(
                            title: 'American Restaurants',
                            branches: americanBranches,
                            restaurants: american),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
