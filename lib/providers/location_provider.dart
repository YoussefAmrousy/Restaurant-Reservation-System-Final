import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _selectedLocation;

  LatLng? get selectedLocation => _selectedLocation;

  void setSelectedLocation(LatLng location) {
    _selectedLocation = location;
    notifyListeners();
  }
}
