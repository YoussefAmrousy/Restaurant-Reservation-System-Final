// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservy/Services/branch_service.dart';
import 'package:reservy/Utils/util.dart';
import 'package:reservy/models/branch.dart';

class BranchItem extends StatefulWidget {
  BranchItem({super.key, required this.branch});
  final Branch branch;

  @override
  _BranchtItemState createState() => _BranchtItemState();
}

class _BranchtItemState extends State<BranchItem> {
  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');
  BranchService branchService = BranchService();

  Future<void> initializeData() async {
    await branchService.getBranchesByRestaurant(widget.branch.restaurantName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[100]!, Colors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(4),
        title: Text(
          '${Util.capitalize(widget.branch.area)}, ${Util.capitalize(widget.branch.city)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          widget.branch.address == null
              ? ''
              : Util.capitalize(widget.branch.address!),
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
