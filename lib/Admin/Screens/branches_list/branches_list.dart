// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/Admin/Screens/branch_creation.dart';
import 'package:restaurant_reservation_final/Admin/Screens/branches_list/branch_dialog_details.dart';
import 'package:restaurant_reservation_final/Admin/Screens/branches_list/branch_item_widget.dart';
import 'package:restaurant_reservation_final/Admin/Screens/restaurant_details.dart';
import 'package:restaurant_reservation_final/Utils/branch_collection_utils.dart';
import 'package:restaurant_reservation_final/models/branch.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';

class BranchesListScreen extends StatefulWidget {
  BranchesListScreen({super.key, required this.restaurant});
  Restaurant restaurant;

  @override
  _BranchesListState createState() => _BranchesListState();
}

class _BranchesListState extends State<BranchesListScreen> {
  BranchCollectionUtils branchCollectionUtils = BranchCollectionUtils();
  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await branchCollectionUtils.fetchBranches(widget.restaurant.name);
    setState(() {});
  }

  Future<void> deleteBranch(String address) async {
    final branchQuery = await branchesCollection
        .where('restaurant', isEqualTo: widget.restaurant.name)
        .get();
    if (branchQuery.docs.isNotEmpty) {
      final branchFound = branchQuery.docs.first;
      await branchFound.reference.delete();
      initializeData();
    }
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
                    deleteBranch(branch.address!),
                    setState(() => {}),
                    Navigator.of(context).pop()
                  }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(236, 235, 235, 1),
        title: Text(
          '${widget.restaurant.name} Branches',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
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

              await branchCollectionUtils.fetchBranches(widget.restaurant.name);
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          branchCollectionUtils.branches.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No branches available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: branchCollectionUtils.branches.length,
                  itemBuilder: (context, index) {
                    final branch = branchCollectionUtils.branches[index];
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
