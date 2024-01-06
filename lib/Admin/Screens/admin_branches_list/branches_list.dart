// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:reservy/Admin/Screens/admin_branches_list/branch_dialog_details.dart';
import 'package:reservy/Admin/Screens/admin_branches_list/branch_item_widget.dart';
import 'package:reservy/Admin/Screens/admin_restaurant_details.dart';
import 'package:reservy/Admin/Screens/branch_creation.dart';
import 'package:reservy/Services/branch_service.dart';
import 'package:reservy/shared/Utils/map_util.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/providers/location_provider.dart';
import 'package:reservy/shared/Widgets/not_available.dart';

class BranchesListScreen extends StatefulWidget {
  BranchesListScreen({super.key, required this.restaurant});
  Restaurant restaurant;

  @override
  _BranchesListState createState() => _BranchesListState();
}

class _BranchesListState extends State<BranchesListScreen> {
  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  BranchService branchService = BranchService();
  MapUtil mapUtil = MapUtil();
  late Position _position;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await branchService.getBranchesByRestaurant(widget.restaurant.name!);
    setState(() {});
  }

  Future<void> deleteBranch(String id) async {
    branchService.deleteBranch(id);
    initializeData();
  }

  void _showBranchDetailsDialog(BuildContext context, Branch branch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BranchDetailsDialogDetails(
              branch: branch,
              onBranchDeleted: () => {
                    deleteBranch(branch.id!),
                    setState(() => {}),
                    Navigator.of(context).pop()
                  }),
        );
      },
    );
  }

  setUserCurrentLocation() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    _position = await mapUtil.getCurrentLocation();
    locationProvider.setCurrentUserLocation(_position);
  }

  @override
  Widget build(BuildContext context) {
    setUserCurrentLocation();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Color(0xC1E7AF2F),
          title: Text(
            '${widget.restaurant.name} Branches',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailsScreen(
                    restaurant: widget.restaurant,
                  ),
                ),
              ),
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BranchCreationScreen(
                      restaurant: widget.restaurant,
                    ),
                  ),
                );

                await branchService
                    .getBranchesByRestaurant(widget.restaurant.name!);
                setState(() {});
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          branchService.branches.isEmpty
              ? NotAvailable(message: 'branches')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: branchService.branches.length,
                  itemBuilder: (context, index) {
                    final branch = branchService.branches[index];
                    return GestureDetector(
                      onTap: () => _showBranchDetailsDialog(context, branch),
                      child: BranchItem(
                        branch: branch,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
