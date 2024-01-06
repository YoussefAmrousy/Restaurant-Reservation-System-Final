// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/user/models/reservy_model.dart';

class BookingTabWidget extends StatefulWidget {
  BookingTabWidget(
      {super.key,
      required this.branch,
      required this.restaurant,
      required this.model});
  Branch branch;
  Restaurant restaurant;
  ReservyModel model;

  @override
  _BookingTabWidgetState createState() => _BookingTabWidgetState();
}

class _BookingTabWidgetState extends State<BookingTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Icon(
                Icons.person_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24,
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Text(
                'Guests',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFF313131),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        Container(
          width: 160,
          height: 50,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Color(0xFFE7AF2F),
              width: 2,
            ),
          ),
          child: FlutterFlowCountController(
            decrementIconBuilder: (enabled) => FaIcon(
              FontAwesomeIcons.minus,
              color: enabled
                  ? FlutterFlowTheme.of(context).secondaryText
                  : FlutterFlowTheme.of(context).alternate,
              size: 20,
            ),
            incrementIconBuilder: (enabled) => FaIcon(
              FontAwesomeIcons.plus,
              color: enabled
                  ? Color(0xFFE7AF2F)
                  : FlutterFlowTheme.of(context).alternate,
              size: 20,
            ),
            countBuilder: (count) => Text(
              count.toString(),
              style: FlutterFlowTheme.of(context).titleLarge,
            ),
            count: widget.model.countControllerValue,
            updateCount: (count) =>
                setState(() => widget.model.countControllerValue = count),
            stepSize: 1,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 2,
          color: Color(0xFFAAAAAA),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 90),
              child: CupertinoButton(
                child: Text(
                  widget.model.selectedDate == null
                      ? 'Choose Date'
                      : '${DateFormat('EEEE').format(widget.model.selectedDate!)}, ${widget.model.selectedDate!.day}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                onPressed: () {
                  _openDatePopup(context);
                },
              ),
            ),
            CupertinoButton(
              child: Text(
                widget.model.time == null ? 'Choose Time' : widget.model.time!,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onPressed: () {
                _openTimePopup(context);
              },
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 8,
        ),
        Divider(
          thickness: 2,
          color: Color(0xFFAAAAAA),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 250,
          child: FFButtonWidget(
            onPressed: () {
              final isValid = widget.model.validateForm();
              if (isValid) {
                widget.model.reserve(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please fill all fields',
                    ),
                  ),
                );
              }
            },
            text: 'Reserve Now',
            options: FFButtonOptions(
              height: 40,
              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              color: Color(0xFFE7AF2F),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFFECEBEB),
                    fontSize: 14,
                  ),
              elevation: 3,
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  void _openTimePopup(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime minTime = DateTime(now.year, now.month, now.day, 8, 0);
    DateTime maxTime = DateTime(now.year, now.month, now.day, 22, 0);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          minimumDate: minTime,
          maximumDate: maxTime,
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              widget.model.time = DateFormat('hh:mm a').format(newTime);
            });
          },
          mode: CupertinoDatePickerMode.time,
        ),
      ),
    );
  }

  void _openDatePopup(BuildContext context) {
    DateTime initialDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          minimumDate: DateTime.now(),
          maximumDate: DateTime.now().add(Duration(days: 7)),
          dateOrder: DatePickerDateOrder.dmy,
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              widget.model.selectedDate = DateTime(
                initialDateTime.year,
                initialDateTime.month,
                newTime.day,
                newTime.hour,
                newTime.minute,
              );
              initialDateTime = widget.model.selectedDate!;
            });
          },
          mode: CupertinoDatePickerMode.date,
        ),
      ),
    );
  }
}
