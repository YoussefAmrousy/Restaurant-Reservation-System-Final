// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, must_be_immutable

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:reservy/models/reservation.dart';
import 'package:reservy/shared/Utils/util.dart';

class RestaurantReservationCard extends StatefulWidget {
  RestaurantReservationCard({super.key, this.reservation});
  Reservation? reservation;

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<RestaurantReservationCard> {
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${widget.reservation?.date?.day} ${Util.getMonthAbbreviation(widget.reservation!.date!.month)} ${widget.reservation?.date!.year}";
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Align(
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
                        widget.reservation!.username!,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          color: Color(0xFFFCFAF9),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  widget.reservation!.time!,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        color: Color(0xFFFCFAF9),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${widget.reservation!.guests} guests table',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        color: Color(0xFFFCFAF9),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
