// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference userRoles =
      FirebaseFirestore.instance.collection('userRoles');

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user!;
    } catch (error) {
      print('Error signing in: $error');
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password,
      [String? type]) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      await addUserRole(user!.uid, type ?? "user");
      print(user);
      return user;
    } catch (error) {
      print('Error registering: $error');
      return null;
    }
  }

  Future<void> addUserRole(String userId, String role) async {
    try {
      final userRole = {
        'userId': userId,
        'role': role,
      };
      await userRoles.add(userRole);
    } catch (error) {
      print('Error adding user role: $error');
      return;
    }
  }

  Future<String?> getUserRole(String userId) async {
    try {
      final userRoleQuery =
          await userRoles.where('userId', isEqualTo: userId).get();
      if (userRoleQuery.docs.isNotEmpty) {
        return userRoleQuery.docs.first.get('role');
      }
      return null;
    } catch (error) {
      print('Error getting user role: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print('Error signing out: $error');
      rethrow;
    }
  }
}
