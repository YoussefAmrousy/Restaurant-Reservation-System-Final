// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      print(user);
      return user;
    } catch (error) {
      print('Error registering: $error');
      return null;
    }
  }

  // Future<void> _addUserRole(String uid, String role) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('user_roles').doc(uid).set({
  //       'role': role,
  //     });
  //   } catch (e) {
  //     print('Error adding user role: $e');
  //   }
  // }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print('Error signing out: $error');
      rethrow;
    }
  }
}
