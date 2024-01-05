// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:reservy/models/branch.dart';

class RestaurantDetailsHeaderWidget extends StatelessWidget {
  RestaurantDetailsHeaderWidget({super.key, required this.branch});
  Branch branch;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0, 0),
            child: ClipRRect(
              child: Image.asset(
                'assets/restaurant.jpeg',
                width: screenWidth,
                height: screenHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, 1.03),
            child: Container(
              width: screenWidth,
              height: 41,
              decoration: BoxDecoration(
                color: Color(0x40000000),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Text(
                      "${branch.area}, ${branch.city}",
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            color: Color(0xFFFCFAF9),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
