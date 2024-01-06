// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:reservy/shared/Utils/util.dart';
import 'package:reservy/models/reservation.dart';

class ReservationCard extends StatefulWidget {
  ReservationCard({super.key, required this.reservation});
  Reservation reservation;

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${widget.reservation.date!.day} ${Util.getMonthAbbreviation(widget.reservation.date!.month)} ${widget.reservation.date!.year}";
    return FlipCard(
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
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                  widget.reservation.restaurant!,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFFFCFAF9),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text(
                widget.reservation.time!,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFFFCFAF9),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Text(
                '${widget.reservation.guests} Guests Table',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
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
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Tap on QR Code for easier scanning',
                    textAlign: TextAlign.right,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
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
    );
  }
}
