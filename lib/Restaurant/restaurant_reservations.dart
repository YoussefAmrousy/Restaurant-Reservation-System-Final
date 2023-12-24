// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, must_be_immutable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_reservation_final/Restaurant/restaurant_reservation_model.dart';
import 'package:restaurant_reservation_final/Services/auth_service.dart';
import 'package:restaurant_reservation_final/Services/reservations_service.dart';
import 'package:restaurant_reservation_final/Services/shared_preference_service.dart';
import 'package:restaurant_reservation_final/Utils/reservations_collection_utils.dart';

class ReservationsWidget extends StatefulWidget {
  ReservationsWidget({super.key, this.restaurant});
  String? restaurant;

  @override
  _ReservationsWidgetState createState() => _ReservationsWidgetState();
}

class _ReservationsWidgetState extends State<ReservationsWidget> {
  late ReservationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService authService = AuthService();
  User user = FirebaseAuth.instance.currentUser!;
  String? restaurantName;
  ReservationsService reservationsService = ReservationsService();
  ReservationsCollectionUtils reservationsCollectionUtils =
      ReservationsCollectionUtils();
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservationsModel());
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
                      String formattedDate =
                          "${reservation.date.day} ${reservationsCollectionUtils.getMonthAbbreviation(reservation.date.month)} ${reservation.date.year}";
                      return Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: FlipCard(
                          fill: Fill.fillBack,
                          direction: FlipDirection.HORIZONTAL,
                          speed: 400,
                          front: Container(
                            width: 379,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xC1E7AF2F), Color(0x51E7AF2F)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(0, -1),
                                end: AlignmentDirectional(0, 1),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(1, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0, 1),
                                    child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        reservation.username,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFFFCFAF9),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          back: Container(
                            width: 379,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xC1E7AF2F), Color(0x51E7AF2F)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(0, -1),
                                end: AlignmentDirectional(0, 1),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Text(
                                    formattedDate,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFFCFAF9),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Text(
                                  reservation.time,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFFCFAF9),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '5 Guests Table',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFFCFAF9),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
