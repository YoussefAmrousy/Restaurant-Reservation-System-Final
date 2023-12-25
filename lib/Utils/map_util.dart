// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtil {
  openGoogleMapsNavigation(BuildContext context, LatLng destination) async {
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}'
        '&travelmode=driving';
    Uri googleMapsUri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch Google Maps.'),
        ),
      );
    }
  }
}
