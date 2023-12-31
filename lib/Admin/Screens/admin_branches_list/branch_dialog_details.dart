// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:reservy/models/branch.dart';

class BranchDetailsDialogDetails extends StatelessWidget {
  BranchDetailsDialogDetails({
    super.key,
    required this.branch,
    required this.onBranchDeleted,
  });

  final Branch branch;
  final Function() onBranchDeleted;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFDFAF3),
                  Color(0xFFD6D1BB),
                ],
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name!,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Location:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text('${branch.area}, ${branch.city}'),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Address:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(branch.address!),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Phone:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(branch.phone),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    SizedBox(
                      height: 30.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        onPressed: () {
                          onBranchDeleted();
                        },
                        child: Text(
                          'Delete Branch',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
