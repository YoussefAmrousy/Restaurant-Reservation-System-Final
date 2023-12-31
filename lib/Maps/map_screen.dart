// MapScreen.dart
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_declarations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reservy/Utils/map_util.dart';
import 'package:reservy/providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key, this.selectedLocation, required this.allowMarkerSelection});
  final LatLng? selectedLocation;
  final bool allowMarkerSelection;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  MapUtil mapUtil = MapUtil();
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(30.044482051923598, 31.232991437944793),
            zoom: 12.0,
          ),
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          compassEnabled: true,
          onMapCreated: (controller) {
            setState(() {
              _mapController = controller;
              if (widget.selectedLocation != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(widget.selectedLocation!),
                );
                _selectedMarker = Marker(
                  markerId: MarkerId('selected_location'),
                  position: widget.selectedLocation!,
                  infoWindow: InfoWindow(title: 'Selected Location'),
                );
              }
            });
          },
          onTap: (LatLng selectedLocation) {
            if (!widget.allowMarkerSelection) {
              return;
            }
            setState(() {
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(selectedLocation),
              );

              _selectedMarker = Marker(
                markerId: MarkerId('selected_location'),
                position: selectedLocation,
                infoWindow: InfoWindow(title: 'Selected Location'),
              );
            });
            locationProvider.setSelectedLocation(selectedLocation);
          },
          markers: _selectedMarker != null ? {_selectedMarker!} : {},
          mapType: MapType.normal,
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () async {
              getUserCurrentLocation().then((value) async {
                CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 14,
                );

                _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));
                setState(() {});
              });
            },
            child: Icon(Icons.local_activity),
          ),
        ),
      ],
    );
  }
}
