import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String? id;
  String? name;
  String? cuisine;
  String? phone;
  String? socialMedia;
  String? website;
  String? logoPath;
  String? menuPath;
  double? rating;
  int? ratingCount;
  String? popularFood;
  String? email;

  Restaurant({
    this.id,
    this.name,
    this.cuisine,
    this.menuPath,
    this.phone,
    this.socialMedia,
    this.website,
    this.logoPath,
    this.rating = 0,
    this.ratingCount = 0,
    this.popularFood,
    this.email,
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
      'ratingCount': ratingCount,
      'popularFood': popularFood,
      'email': email
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map, String id) {
    return Restaurant(
      id: id,
      name: map['name'],
      cuisine: map['cuisine'],
      phone: map['phone'],
      socialMedia: map['socialMedia'],
      website: map['website'],
      menuPath: map['menuPath'],
      logoPath: map['logoPath'],
      rating: map['rating'] ?? 0,
      ratingCount: map['ratingCount'] ?? 0,
      popularFood: map['popularFood'],
      email: map['email'],
    );
  }

  factory Restaurant.fromSnapshot(DocumentSnapshot doc) {
    return Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
