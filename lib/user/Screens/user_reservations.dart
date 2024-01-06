// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/reservations_service.dart';
import 'package:reservy/models/reservation.dart';
import 'package:reservy/user/Widgets/reservation_card.dart';

class UserReservationsWidget extends StatefulWidget {
  const UserReservationsWidget({super.key});

  @override
  _UserReservationsWidgetState createState() => _UserReservationsWidgetState();
}

class _UserReservationsWidgetState extends State<UserReservationsWidget> {
  ReservationsService reservationsService = ReservationsService();
  AuthService authService = AuthService();
  List<Reservation>? reservations = [];
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    String userId = user.uid;
    getReservations(userId);
  }

  getReservations(String userId) async {
    final reservationsQuery =
        await reservationsService.getReservationsByUserId(userId);
    setState(() {
      reservations = reservationsQuery;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'My Reservations',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(236, 235, 235, 0),
          elevation: 0,
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
                  itemCount: reservations?.length,
                  itemBuilder: ((context, index) {
                    final reservation = reservations?[index];
                    return Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ReservationCard(
                          reservation: reservation!,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
