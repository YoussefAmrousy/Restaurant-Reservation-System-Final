import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name;
  final String cuisine;
  final String? phone;
  final String? socialMedia;
  final String? website;
  final bool isActive;
  final String? menu;

  Restaurant({
    required this.name,
    required this.cuisine,
    required this.isActive,
    required this.menu,
    this.phone,
    this.socialMedia,
    this.website,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      name: map['name'],
      cuisine: map['cuisine'],
      isActive: map['isActive'],
      phone: map['phone'],
      socialMedia: map['socialMedia'],
      website: map['website'],
      menu: map['menu'],
    );
  }

  factory Restaurant.fromFireStore(DocumentSnapshot doc) {
    return Restaurant(
      name: doc['name'],
      cuisine: doc['cuisine'],
      isActive: doc['isActive'],
      phone: doc['phone'],
      socialMedia: doc['socialMedia'],
      website: doc['website'],
      menu: doc['menu'],
    );
  }
}
