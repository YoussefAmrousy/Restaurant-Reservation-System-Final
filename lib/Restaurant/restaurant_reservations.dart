// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, must_be_immutable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:reservy/Restaurant/Widgets/restaurant_reservation_card.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/reservations_service.dart';
import 'package:reservy/Services/shared_preference_service.dart';

class ReservationsWidget extends StatefulWidget {
  ReservationsWidget({super.key, this.restaurant});
  String? restaurant;

  @override
  _ReservationsWidgetState createState() => _ReservationsWidgetState();
}

class _ReservationsWidgetState extends State<ReservationsWidget> {
  AuthService authService = AuthService();
  User user = FirebaseAuth.instance.currentUser!;
  String? restaurantName;
  ReservationsService reservationsService = ReservationsService();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  @override
  void initState() {
    super.initState();
    getReservationsByRestaurant();
    setState(() {});
  }

  getReservationsByRestaurant() async {
    try {
      await reservationsService.getReservationsByRestaurant(widget.restaurant!);
      setState(() {});
    } catch (error) {
      print('Error getting reservations: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Text(
              'Reservy',
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Poppins',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            backgroundColor: Color(0xC1E7AF2F),
            automaticallyImplyLeading: true,
            actions: [],
            leading: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await authService.signOut();
                  Navigator.pushNamed(context, '/login');
                }),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            elevation: 12,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: reservationsService.reservations.length,
                    itemBuilder: (context, index) {
                      var reservation = reservationsService.reservations[index];
                      return RestaurantReservationCard(
                          reservation: reservation);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
