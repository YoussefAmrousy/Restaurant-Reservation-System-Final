// MapScreen.dart
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: widget.selectedLocation == null,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
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
          initialCameraPosition: CameraPosition(
            target: LatLng(
                locationProvider.currentUserLocation?.latitude ?? 0.0,
                locationProvider.currentUserLocation?.longitude ?? 0.0),
            zoom: 12.0,
          ),
          markers: _selectedMarker != null ? {_selectedMarker!} : {},
          mapType: MapType.normal,
        ),
        widget.selectedLocation != null
            ? Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  onPressed: () {
                    if (_selectedMarker != null) {
                      mapUtil.openGoogleMapsNavigation(
                          context, _selectedMarker!.position);
                    }
                  },
                  mini: true,
                  child: Icon(Icons.directions, color: Colors.white),
                ),
              )
            : Container(),
      ],
    );
  }
}
