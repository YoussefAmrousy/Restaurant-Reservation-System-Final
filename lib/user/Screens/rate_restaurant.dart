// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:reservy/Services/reservations_service.dart';
import 'package:reservy/Services/restaurant_service.dart';
import 'package:reservy/Utils/util.dart';
import 'package:reservy/models/reservation.dart';

class RateRestaurant extends StatefulWidget {
  RateRestaurant({super.key, required this.reservation});
  Reservation reservation;

  @override
  _RateRestaurantState createState() => _RateRestaurantState();

  static Future<void> showRatingPopup(
      BuildContext context, Reservation reservation) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: RateRestaurant(
            reservation: reservation,
          ),
        );
      },
    );
  }
}

class _RateRestaurantState extends State<RateRestaurant> {
  double ratingBarValue = 0;
  ReservationsService reservationsService = ReservationsService();
  RestaurantService restaurantService = RestaurantService();

  Future<void> setReservationAsRated() async {
    widget.reservation.rated = true;
    await reservationsService.updateReservation(widget.reservation);
  }

  Future<void> rateRestaurant() async {
    await restaurantService.rateRestaurant(
        widget.reservation.restaurant!, ratingBarValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Thank You for Visiting ${widget.reservation.restaurant} on ${_formattedDate()}!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Please rate your experience:",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          RatingBar.builder(
            onRatingUpdate: (newValue) =>
                setState(() => ratingBarValue = newValue),
            itemBuilder: (context, index) => Icon(
              Icons.star_rounded,
              color: Color(0xFFE7AF2F),
            ),
            direction: Axis.horizontal,
            unratedColor: FlutterFlowTheme.of(context).secondaryText,
            itemCount: 5,
            itemSize: 30,
            glowColor: Color(0xFF313131),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE7AF2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (ratingBarValue == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please submit your rating!"),
                  ),
                );
                return;
              }
              Navigator.of(context).pop();
              setReservationAsRated();
              rateRestaurant();
            },
            child: Text('Rate Now!',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    return "${widget.reservation.date!.day} ${Util.getMonthAbbreviation(widget.reservation.date!.month)}";
  }
}
