// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_reservation_final/Services/shared_preference_service.dart';
import 'package:restaurant_reservation_final/models/user_data.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('userData');
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
      UserData userData) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      UserData newUser = UserData(
        userId: user!.uid,
        username: userData.username,
        role: userData.role,
      );

      if (userData.role == 'restaurant') {
        newUser.restaurant = userData.restaurant;
        await addUserData(newUser);

        sharedPreferenceService.saveStringToLocalStorage(
            'restaurant', userData.restaurant!);
      } else {
        await addUserData(newUser);
      }
      print(user);
      return user;
    } catch (error) {
      print('Error registering: $error');
      return null;
    }
  }

  Future<void> addUserData(UserData userData) async {
    try {
      final user = {
        'username': userData.username,
        'userId': userData.userId,
        'role': userData.role,
        'restaurant': userData.restaurant ?? '',
      };
      await userDataCollection.add(user);
    } catch (error) {
      print('Error adding user role: $error');
      return;
    }
  }

  Future<String?> getUserRole(String userId) async {
    try {
      final userRoleQuery =
          await userDataCollection.where('userId', isEqualTo: userId).get();
      if (userRoleQuery.docs.isNotEmpty) {
        return userRoleQuery.docs.first.get('role');
      }
      return null;
    } catch (error) {
      print('Error getting user role: $error');
      return null;
    }
  }

  Future<UserData> getUserData(String userId) async {
      final userDataQuery =
          await userDataCollection.where('userId', isEqualTo: userId).get();
      if (userDataQuery.docs.isEmpty) return UserData();
      var user = userDataQuery.docs.first;
      return UserData.fromSnapshot(user);
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
      final userRoleQuery = userDataCollection.where('userId', isEqualTo: uid).get();
      return await userRoleQuery
          .then((value) => value.docs.first.get('restaurant'));
    } catch (error) {
      print('Error getting user restaurnt: $error');
      return null;
    }
  }
}
