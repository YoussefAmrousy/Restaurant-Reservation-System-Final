import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? userId;
  final String? username;
  final String? role;
  final String? restaurant;
  final String? email;

  UserData({this.restaurant, this.userId, this.username, this.role, this.email});

  factory UserData.fromSnapshot(DocumentSnapshot doc) {
    return UserData(
      userId: doc['userId'],
      username: doc['username'],
      role: doc['role'],
      restaurant: doc['restaurant'],
      email: doc['email'],
    );
  }
}
