import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String? name;
  String? cuisine;
  String? phone;
  String? socialMedia;
  String? website;
  String? logoPath;
  String? menuPath;
  double? rating;
  int? ratingCount;

  Restaurant({
    this.name,
    this.cuisine,
    this.menuPath,
    this.phone,
    this.socialMedia,
    this.website,
    this.logoPath,
    this.rating = 0,
    this.ratingCount = 0
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cuisine': cuisine,
      'phone': phone,
      'socialMedia': socialMedia,
      'website': website,
      'logoPath': logoPath,
      'menuPath': menuPath,
      'rating': rating,
      'ratingCount': ratingCount
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      name: map['name'],
      cuisine: map['cuisine'],
      phone: map['phone'],
      socialMedia: map['socialMedia'],
      website: map['website'],
      menuPath: map['menuPath'],
      logoPath: map['logoPath'],
      rating: map['rating'] ?? 0,
      ratingCount: map['ratingCount'] ?? 0
    );
  }

  factory Restaurant.fromSnapshot(DocumentSnapshot doc) {
    return Restaurant(
      name: doc['name'],
      cuisine: doc['cuisine'],
      phone: doc['phone'],
      socialMedia: doc['socialMedia'],
      website: doc['website'],
      menuPath: doc['menuPath'],
      logoPath: doc['logoPath'],
      rating: doc['rating'] ?? 0,
      ratingCount: doc['ratingCount'] ?? 0
    );
  }
}
