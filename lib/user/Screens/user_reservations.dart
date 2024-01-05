// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/reservations_service.dart';
import 'package:reservy/Utils/util.dart';
import 'package:reservy/models/reservation.dart';
import 'package:reservy/user/Widgets/reservation_card.dart';
import 'package:reservy/user/models/user_reservation_model.dart';

class UserReservationsWidget extends StatefulWidget {
  const UserReservationsWidget({super.key});

  @override
  _UserReservationsWidgetState createState() => _UserReservationsWidgetState();
}

class _UserReservationsWidgetState extends State<UserReservationsWidget> {
  late UserReservationsModel _model;
  ReservationsService reservationsService = ReservationsService();
  AuthService authService = AuthService();
  List<Reservation>? reservations = [];
  User user = FirebaseAuth.instance.currentUser!;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Util util = Util();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserReservationsModel());
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
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
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
                        padding: const EdgeInsets.all(8.0),
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
