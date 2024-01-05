// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/user/models/reservy_model.dart';

class RestaurantRatingWidget extends StatefulWidget {
  RestaurantRatingWidget({super.key, required this.model, required this.restaurant});
  ReservyModel model;
  Restaurant restaurant;

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RestaurantRatingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393,
      height: 35,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: IgnorePointer(
        ignoring: true,
        child: RatingBar.builder(
          onRatingUpdate: (newValue) =>
              setState(() => widget.model.ratingBarValue = newValue),
          itemBuilder: (context, index) => Icon(
            Icons.star_rounded,
            color: Color(0xFFE7AF2F),
          ),
          direction: Axis.horizontal,
          initialRating: widget.restaurant.rating!,
          unratedColor: FlutterFlowTheme.of(context).secondaryText,
          itemCount: 5,
          itemSize: 30,
          glowColor: Color(0xFF313131),
        ),
      ),
    );
  }
}
