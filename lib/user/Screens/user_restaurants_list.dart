// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/branch_service.dart';
import 'package:reservy/Services/restaurant_service.dart';
import 'package:reservy/Utils/map_util.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/providers/location_provider.dart';
import 'package:reservy/shared/Widgets/not_available.dart';
import 'package:reservy/user/Widgets/restaurants_list_row.dart';

class UserRestaurantsList extends StatefulWidget {
  const UserRestaurantsList({super.key});

  @override
  _UserRestaurantsListState createState() => _UserRestaurantsListState();
}

class _UserRestaurantsListState extends State<UserRestaurantsList> {
  BranchService branchService = BranchService();
  RestaurantService restaurantService = RestaurantService();
  AuthService authService = AuthService();
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  List<Restaurant> italian = [];
  List<Restaurant> japanese = [];
  List<Restaurant> american = [];
  List<Branch> italianBranches = [];
  List<Branch> japaneseBranches = [];
  List<Branch> americanBranches = [];
  Position? currentLocation;

  @override
  void initState() {
    super.initState();
    getBranches();
    getAllRestaurants();
    _scrollController.addListener(_onScroll);
    loadDataProgressBar();
    getNearbyRestaurants();
  }

  loadDataProgressBar() async {
    setState(() {
      _isRefreshing = true;
    });
    await Future.delayed(Duration(seconds: 6));
    setState(() {
      _isRefreshing = false;
    });
  }

  Future<void> getBranches() async {
    var branches = await branchService.getAllBranches();
    branchService.branches = branches;
    italianBranches = branches.where((e) => e.cuisine == 'italian').toList();
    japaneseBranches = branches.where((e) => e.cuisine == 'japanese').toList();
    americanBranches = branches.where((e) => e.cuisine == 'american').toList();
  }

  Future<void> refreshData() async {
    setState(() {
      searchController.clear();
      _isRefreshing = true;
    });

    await getBranches();
    await getNearbyRestaurants();
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      return;
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      refreshData();
    }
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
    LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    MapUtil mapUtil = MapUtil();
    currentLocation = locationProvider.currentUserLocation ??
        await mapUtil.getCurrentLocation();

    List<Branch> nearbyBranches =
        branchService.getNearbyBranches(currentLocation!);

    setState(() {
      branchService.nearbyBranches = nearbyBranches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 50,
            elevation: 0,
            title: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 5),
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
                decoration: InputDecoration(
                  hintText: "I'm looking for..",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          SliverFillRemaining(
            child: _isRefreshing
                ? Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: Colors.black.withOpacity(0.5),
                    onRefresh: refreshData,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
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
                            SizedBox(height: 8),
                            branchService.branches.isEmpty
                                ? NotAvailable(message: 'restaurants')
                                : Column(
                                    children: [
                                      RestaurantsListRow(
                                        title: 'Neraby Restaurants',
                                        branches: branchService.nearbyBranches,
                                        restaurants:
                                            restaurantService.restaurants,
                                        currentLocation: currentLocation!,
                                      ),
                                      RestaurantsListRow(
                                        title: 'Italian Restaurants',
                                        branches: italianBranches,
                                        restaurants: italian,
                                        currentLocation: currentLocation!,
                                      ),
                                      RestaurantsListRow(
                                          title: 'Japanese Restaurants',
                                          branches: japaneseBranches,
                                          restaurants: japanese,
                                          currentLocation: currentLocation!,
                                      ),
                                      RestaurantsListRow(
                                          title: 'American Restaurants',
                                          branches: americanBranches,
                                          restaurants: american,
                                          currentLocation: currentLocation!,
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
