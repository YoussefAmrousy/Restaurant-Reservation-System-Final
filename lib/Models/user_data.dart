import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? userId;
  final String? username;
  final String? role;
  String? restaurant;

  UserData({this.restaurant, this.userId, this.username, this.role});

  factory UserData.fromSnapshot(DocumentSnapshot doc) {
    return UserData(
      userId: doc['userId'],
      username: doc['username'],
      role: doc['role'],
      restaurant: doc['restaurant'],
    );
  }
}
