import 'package:cloud_firestore/cloud_firestore.dart';

class Branch {
  final String? id;
  final String restaurantName;
  final String area;
  final String city;
  final String? address;
  final String phone;
  final double? longitude;
  final double? latitude;
  final String? cuisine;

  Branch(
      {this.id,
      required this.restaurantName,
      required this.area,
      required this.city,
      required this.phone,
      this.address,
      this.longitude,
      this.latitude,
      this.cuisine});

  factory Branch.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Branch(
      id: data['id'],
      area: data['area'],
      city: data['city'],
      phone: data['phone'],
      restaurantName: data['restaurant'],
      address: data['address'],
      longitude: data['longitude'],
      latitude: data['latitude'],
      cuisine: data['cuisine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant': restaurantName,
      'area': area,
      'city': city,
      'address': address,
      'phone': phone,
      'longitude': longitude,
      'latitude': latitude,
      'cuisine': cuisine,
    };
  }
}
