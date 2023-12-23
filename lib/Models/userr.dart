// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';

class Userr {
  final User firebaseUser;
  final String role;

  Userr({
    required this.firebaseUser,
    required this.role,
  });
}
