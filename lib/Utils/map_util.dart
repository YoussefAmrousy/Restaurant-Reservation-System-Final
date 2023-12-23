// ignore_for_file: unused_element, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class MapUtil {
  void saveLocation(LatLng location) async {
    await FirebaseFirestore.instance.collection('locations').add({
      'latitude': location.latitude,
      'longitude': location.longitude,
    });
  }

  Future<List<LatLng>> getLocations() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('locations').get();
      return snapshot.docs.map((doc) {
        double latitude = doc['latitude'] ?? 0.0;
        double longitude = doc['longitude'] ?? 0.0;
        return LatLng(latitude, longitude);
      }).toList();
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

}
