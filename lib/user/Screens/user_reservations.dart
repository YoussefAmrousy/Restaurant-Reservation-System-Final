// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/Services/reservations_service.dart';
import 'package:reservy/Utils/util.dart';
import 'package:reservy/models/reservation.dart';
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Color(0xFFE7AF2F),
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                'My Reservations',
                style: FlutterFlowTheme.of(context).displaySmall.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            elevation: 12,
            iconTheme: IconThemeData(
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
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
                  itemCount: reservations?.length,
                  itemBuilder: ((context, index) {
                    final reservation = reservations?[index];
                    String formattedDate =
                        "${reservation?.date!.day} ${util.getMonthAbbreviation(reservation!.date!.month)} ${reservation.date!.year}";
                    return Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlipCard(
                          fill: Fill.fillBack,
                          direction: FlipDirection.HORIZONTAL,
                          speed: 400,
                          front: Container(
                            width: 379,
                            height: 188,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xC1E7AF2F), Color(0x51E7AF2F)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(0, -1),
                                end: AlignmentDirectional(0, 1),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Center(
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
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Center(
                                    child: Text(
                                      reservation.restaurant!,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFCFAF9),
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Tap for the QR Code',
                                        textAlign: TextAlign.right,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFFFCFAF9),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          back: Container(
                            width: 379,
                            height: 183,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xC1E7AF2F), Color(0x51E7AF2F)],
                                stops: [0, 1],
                                begin: AlignmentDirectional(0, -1),
                                end: AlignmentDirectional(0, 1),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, -1),
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
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Text(
                                    reservation.time!,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFFCFAF9),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Text(
                                    '${reservation.guests} Guests Table',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFFCFAF9),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width: 250,
                                            height: 250,
                                            padding: EdgeInsets.all(8),
                                            child: SvgPicture.asset(
                                              'assets/qr_code.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SvgPicture.asset(
                                      'assets/qr_code.svg',
                                      width: 97,
                                      height: 92,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
