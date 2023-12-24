// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_reservation_final/Services/shared_preference_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference userRoles =
      FirebaseFirestore.instance.collection('userRoles');
  SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      var role = await getUserRole(user!.uid);
      if (role == 'restaurant') {
        var restaurant = await getUserRestaurant(user.uid);
        sharedPreferenceService.saveStringToLocalStorage(
            'restaurant', restaurant);
      }
      return user;
    } catch (error) {
      print('Error signing in: $error');
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password,
      [String? type, String? restaurant]) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (type == 'restaurant') {
        await addUserRole(user!.uid, type ?? "restaurant", restaurant);

        sharedPreferenceService.saveStringToLocalStorage(
            'restaurant', restaurant!);
      } else {
        await addUserRole(user!.uid, type ?? "user");
      }
      print(user);
      return user;
    } catch (error) {
      print('Error registering: $error');
      return null;
    }
  }

  Future<void> addUserRole(String userId, String role,
      [String? restaurant]) async {
    try {
      final userRole = {
        'userId': userId,
        'role': role,
        'restaurant': restaurant ?? '',
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

  getUserRestaurant(String uid) async {
    try {
      final userRoleQuery = userRoles.where('userId', isEqualTo: uid).get();
      return await userRoleQuery
          .then((value) => value.docs.first.get('restaurant'));
    } catch (error) {
      print('Error getting user restaurnt: $error');
      return null;
    }
  }
}
