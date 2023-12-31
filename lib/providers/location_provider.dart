import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _selectedLocation;
  Position? _currentUserLocation;

  LatLng? get selectedLocation => _selectedLocation;
  Position? get currentUserLocation => _currentUserLocation;

  void setSelectedLocation(LatLng location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setCurrentUserLocation(Position position) {
    _currentUserLocation = position;
    notifyListeners();
  }
}
