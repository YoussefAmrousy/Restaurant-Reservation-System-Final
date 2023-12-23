// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_reservation_final/Utils/map_util.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  MapUtil mapUtil = MapUtil();
  Marker? _selectedMarker; // Variable to store the selected marker

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        onTap: (location) {
          setState(() {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(location),
            );

            _selectedMarker = Marker(
              markerId: MarkerId('selected_location'),
              position: location,
              infoWindow: InfoWindow(title: 'Selected Location'),
            );
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
        markers: _selectedMarker != null
            ? {_selectedMarker!}
            : {}, // Display only the selected marker
      ),
    );
  }
}
