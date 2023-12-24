import 'package:cloud_firestore/cloud_firestore.dart';

class Branch {
  final String? name;
  final String restaurantName;
  final String area;
  final String city;
  final String? address;
  final String phone;

  Branch({
    this.name,
    required this.restaurantName,
    required this.area,
    required this.city,
    required this.phone,
    this.address,
  });

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      name: map['name'] ?? '',
      area: map['area'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      restaurantName: map['restaurant'] ?? '',
      address: map['address'] ?? '',
    );
  }

  factory Branch.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Branch(
      name: data['name'],
      area: data['area'],
      city: data['city'],
      phone: data['phone'],
      restaurantName: data['restaurant'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'area': area,
      'city': city,
      'phone': phone,
      'restaurant': restaurantName,
      'address': address,
    };
  }
}
