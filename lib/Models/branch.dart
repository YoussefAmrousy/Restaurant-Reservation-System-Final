import 'package:cloud_firestore/cloud_firestore.dart';

class Branch {
  final String restaurantName;
  final String area;
  final String city;
  final String? address;
  final String phone;
  final double? longitude;
  final double? latitude;
  final String? cuisine;

  Branch({
    required this.restaurantName,
    required this.area,
    required this.city,
    required this.phone,
    this.address,
    this.longitude,
    this.latitude,
    this.cuisine
  });

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      area: map['area'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      restaurantName: map['restaurant'] ?? '',
      address: map['address'] ?? '',
      longitude: map['longitude'] ?? 0.0,
      latitude: map['latitude'] ?? 0.0,
      cuisine: map['cuisine'] ?? '',
    );
  }

  factory Branch.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Branch(
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
      'area': area,
      'city': city,
      'phone': phone,
      'restaurant': restaurantName,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'cuisine': cuisine,
    };
  }
}
