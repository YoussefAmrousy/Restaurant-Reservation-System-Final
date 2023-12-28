// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:ui';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:restaurant_reservation_final/Maps/map_screen.dart';
import 'package:restaurant_reservation_final/Services/restaurant_service.dart';
import 'package:restaurant_reservation_final/models/branch.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';
import '../models/reservy_model.dart';
export '../models/reservy_model.dart';

class ReservyWidget extends StatefulWidget {
  ReservyWidget({super.key, required this.branch, required this.restaurant});
  Branch branch;
  Restaurant restaurant;

  @override
  _ReservyWidgetState createState() => _ReservyWidgetState();
}

class _ReservyWidgetState extends State<ReservyWidget>
    with TickerProviderStateMixin {
  late ReservyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  String? selectedTime;
  RestaurantService restaurantService = RestaurantService();
  String? menuPath;
  maps.LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservyModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 1,
    )..addListener(() => setState(() {}));
    menuPath = widget.restaurant.menuPath;
    if (widget.branch.latitude != null && widget.branch.longitude != null) {
      selectedLocation =
          maps.LatLng(widget.branch.latitude!, widget.branch.longitude!);
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _model.selectedDate) {
      setState(() {
        _model.selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
            backgroundColor: Color(0xFFE7AF2F),
            automaticallyImplyLeading: true,
            actions: [],
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
              Container(
                width: screenWidth * 0.5,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/restaurant.jpeg',
                          width: screenWidth * 0.5,
                          height: screenHeight * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 1.03),
                      child: Container(
                        width: screenWidth * 0.5,
                        height: 41,
                        decoration: BoxDecoration(
                          color: Color(0x40000000),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Text(
                                "${widget.branch.area}, ${widget.branch.city}",
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFFFCFAF9),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 393,
                height: 35,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: RatingBar.builder(
                  onRatingUpdate: (newValue) =>
                      setState(() => _model.ratingBarValue = newValue),
                  itemBuilder: (context, index) => Icon(
                    Icons.star_rounded,
                    color: Color(0xFF313131),
                  ),
                  direction: Axis.horizontal,
                  initialRating: _model.ratingBarValue ??= 3,
                  unratedColor: FlutterFlowTheme.of(context).secondaryText,
                  itemCount: 5,
                  itemSize: 30,
                  glowColor: Color(0xFF313131),
                ),
              ),
              Container(
                width: 401,
                height: 460,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment(0, 0),
                      child: TabBar(
                        labelColor: Color(0xFFE7AF2F),
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                        unselectedLabelStyle: TextStyle(),
                        indicatorColor: Color(0xFFE7AF2F),
                        padding: EdgeInsets.all(4),
                        tabs: [
                          Tab(
                            text: 'Bookings',
                          ),
                          Tab(
                            text: 'Menu',
                          ),
                          Tab(
                            text: 'Details',
                          ),
                        ],
                        controller: _model.tabBarController,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1, -1),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24,
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1, -1),
                                    child: Text(
                                      'Guests',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
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
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
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
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryText
                                        : FlutterFlowTheme.of(context)
                                            .alternate,
                                    size: 20,
                                  ),
                                  incrementIconBuilder: (enabled) => FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: enabled
                                        ? Color(0xFFE7AF2F)
                                        : FlutterFlowTheme.of(context)
                                            .alternate,
                                    size: 20,
                                  ),
                                  countBuilder: (count) => Text(
                                    count.toString(),
                                    style:
                                        FlutterFlowTheme.of(context).titleLarge,
                                  ),
                                  count: _model.countControllerValue,
                                  updateCount: (count) => setState(() =>
                                      _model.countControllerValue = count),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 95),
                                    child: Text(
                                      _model.selectedDate == null
                                          ? 'No date chosen'
                                          : '${DateFormat('EEEE').format(_model.selectedDate!)}, ${_model.selectedDate!.day}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    _model.dropDownValue == null
                                        ? 'No time chosen'
                                        : _model.dropDownValue!,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0, 0, 0, 0),
                                        color: Color(0xFFE7AF2F),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
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
                                        onChanged: (val) => setState(
                                            () => _model.dropDownValue = val),
                                        width: 162,
                                        height: 50,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        hintText: 'Select Time...',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2,
                                        borderColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 2,
                                        borderRadius: 8,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            16, 4, 16, 4),
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
                                    final isValid = _model.validateForm();
                                    if (isValid) {
                                      _model.reserve(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 0, 24, 0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    color: Color(0xFFE7AF2F),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
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
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Blurred background
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ), // Large image
                                        SizedBox(
                                            width: 320,
                                            height: 600,
                                            child: menuPath != null
                                                ? Image.network(
                                                    menuPath!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Text('Menu Unavilable')),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: menuPath != null
                                ? SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.network(menuPath!),
                                  )
                                : SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Text('Menu Unavilable'),
                                  ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 8.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.restaurant_rounded,
                                                  color: Color(0xFFAAAAAA),
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  widget.branch.restaurantName,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFF313131),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    if (widget.restaurant
                                                            .socialMedia !=
                                                        null) {
                                                      _model.launchURL(
                                                          'facebook.com');
                                                    }
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.instagram,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              widget.branch.address == null
                                                  ? ''
                                                  : widget.branch.address!,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFFAAAAAA),
                                                        fontSize: 12,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Cuisine: ${widget.branch.cuisine ?? ''}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFAAAAAA),
                                            fontSize: 12,
                                          ),
                                    ),
                                    Text(
                                      'Phone: ${widget.branch.phone}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFAAAAAA),
                                            fontSize: 12,
                                          ),
                                    ),
                                    Text(
                                        'Website: ${widget.restaurant.website}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFFAAAAAA),
                                              fontSize: 12,
                                            )),
                                    SizedBox(height: 15.0),
                                    Divider(
                                      thickness: 2,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.pin_drop,
                                          color: Color(0xFFAAAAAA),
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          'Click on map to get directions',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Color(0xFF313131),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 250,
                                      height: 150,
                                      child: selectedLocation != null
                                          ? MapScreen(
                                              selectedLocation:
                                                  selectedLocation,
                                              allowMarkerSelection: false,
                                            )
                                          : Text('No Location'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
