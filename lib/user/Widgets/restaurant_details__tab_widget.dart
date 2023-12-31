// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemaps;
import 'package:reservy/Maps/map_screen.dart';
import 'package:reservy/models/branch.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/user/models/reservy_model.dart';

class RestaurantDetailsTabWidget extends StatefulWidget {
  RestaurantDetailsTabWidget(
      {super.key,
      required this.branch,
      required this.restaurant,
      required this.model});
  Branch branch;
  Restaurant restaurant;
  ReservyModel model;

  @override
  _RestaurantDetailsTabWidgetState createState() =>
      _RestaurantDetailsTabWidgetState();
}

class _RestaurantDetailsTabWidgetState
    extends State<RestaurantDetailsTabWidget> {
  googlemaps.LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.branch.latitude != null && widget.branch.longitude != null) {
      selectedLocation = googlemaps.LatLng(widget.branch.latitude!.toDouble(),
          widget.branch.longitude!.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF313131),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              if (widget.restaurant.socialMedia != null) {
                                widget.model
                                    .launchURL(widget.restaurant.socialMedia!);
                              }
                            },
                            icon: widget.restaurant.socialMedia == null
                                ? Container()
                                : widget.restaurant.socialMedia!
                                        .contains('instagram')
                                    ? Icon(
                                        FontAwesomeIcons.instagram,
                                      )
                                    : widget.restaurant.socialMedia!
                                            .contains('facebook')
                                        ? Icon(
                                            FontAwesomeIcons.facebook,
                                          )
                                        : widget.restaurant.socialMedia!
                                                .contains('twitter')
                                            ? Icon(
                                                FontAwesomeIcons.twitter,
                                              )
                                            : Container(),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                widget.branch.address == null ? '' : widget.branch.address!,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFFAAAAAA),
                      fontSize: 12,
                    ),
              ),
              Text(
                'Cuisine: ${widget.branch.cuisine ?? ''}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFFAAAAAA),
                      fontSize: 12,
                    ),
              ),
              Text(
                'Phone: ${widget.branch.phone}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Poppins',
                      color: Color(0xFFAAAAAA),
                      fontSize: 12,
                    ),
              ),
              Text('Website: ${widget.restaurant.website}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
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
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                        selectedLocation: selectedLocation,
                        allowMarkerSelection: false,
                      )
                    : Text('No Location'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
