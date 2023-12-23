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
}
