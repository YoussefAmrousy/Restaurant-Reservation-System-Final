// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/user/Screens/user_restaurant_details.dart';

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
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != widget.model.selectedDate) {
      setState(() {
        widget.model.selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
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
              padding: EdgeInsets.only(right: 95),
              child: Text(
                widget.model.selectedDate == null
                    ? 'No date chosen'
                    : '${DateFormat('EEEE').format(widget.model.selectedDate!)}, ${widget.model.selectedDate!.day}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              widget.model.dropDownValue == null
                  ? 'No time chosen'
                  : widget.model.dropDownValue!,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
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
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 16,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: FFButtonWidget(
                onPressed: () => _selectDate(context),
                text: 'Choose Date',
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
            Flexible(
              child: Align(
                alignment: AlignmentDirectional(1, 0),
                child: FlutterFlowDropDown(
                  options: [
                    '8:00 AM',
                    '9:00 AM',
                    '10:00 AM',
                    '11:00 AM',
                    '12:00 PM',
                    '1:00 PM',
                    '2:00 PM',
                    '3:00 PM',
                    '4:00 PM',
                    '5:00 PM'
                  ],
                  onChanged: (val) =>
                      setState(() => widget.model.dropDownValue = val),
                  width: 162,
                  height: 50,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium,
                  hintText: 'Select Time...',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2,
                  borderColor: FlutterFlowTheme.of(context).alternate,
                  borderWidth: 2,
                  borderRadius: 8,
                  margin: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
                  hidesUnderline: true,
                ),
              ),
            ),
          ],
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
}
