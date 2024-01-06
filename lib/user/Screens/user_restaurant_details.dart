// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/user/Widgets/booking_tab_widget.dart';
import 'package:reservy/user/Widgets/menu_tab_widget.dart';
import 'package:reservy/user/Widgets/restaurant_rating_widget.dart';
import 'package:reservy/user/Widgets/restaurant_details__tab_widget.dart';
import 'package:reservy/user/Widgets/restaurant_details_header_widget.dart';
import 'package:reservy/user/models/reservy_model.dart';

class UserRestaurantDetails extends StatefulWidget {
  UserRestaurantDetails(
      {super.key, required this.branch, required this.restaurant});
  Branch branch;
  Restaurant restaurant;

  @override
  _ReservyWidgetState createState() => _ReservyWidgetState();
}

class _ReservyWidgetState extends State<UserRestaurantDetails>
    with TickerProviderStateMixin {
  late ReservyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReservyModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 1,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.branch.restaurantName,
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Poppins',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            backgroundColor: Color(0xFFE7AF2F),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
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
                height: 0.8,
              ),
              RestaurantDetailsHeaderWidget(branch: widget.branch),
              SizedBox(
                height: 6,
              ),
              RestaurantRatingWidget(
                model: _model,
                restaurant: widget.restaurant,
              ),
              Container(
                width: 460,
                height: 480,
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
                          BookingTabWidget(
                              branch: widget.branch,
                              restaurant: widget.restaurant,
                              model: _model),
                          MenuTabWidget(menuPath: widget.restaurant.menuPath!),
                          RestaurantDetailsTabWidget(
                              branch: widget.branch,
                              restaurant: widget.restaurant,
                              model: _model),
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
