// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/Services/auth_service.dart';
import 'package:restaurant_reservation_final/user/reservations.dart';
import 'package:restaurant_reservation_final/user/restaurant_details.dart';

class ReservyModel extends FlutterFlowModel<ReservyWidget> {
  final unfocusNode = FocusNode();
  double? ratingBarValue;
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  int? countControllerValue;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  DateTime? selectedDate;
  CollectionReference reservationsCollection =
      FirebaseFirestore.instance.collection('reservations');
  AuthService authService = AuthService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }

  bool validateForm() {
    if (countControllerValue == null ||
        countControllerValue! < 1 ||
        countControllerValue! == 0 ||
        dropDownValue == null ||
        dropDownValue!.isEmpty ||
        selectedDate == null) {
      return false;
    }
    return true;
  }

  reserve(BuildContext context) async {
    final Timestamp timestamp = Timestamp.fromDate(selectedDate!);
    User currentUser = FirebaseAuth.instance.currentUser!;
    var userData = await authService.getUserData(currentUser.uid);
    final reservation = {
      'userId': currentUser.uid,
      'username': userData.username,
      'restaurant': widget.branch.restaurantName,
      'date': timestamp,
      'time': dropDownValue,
      'branch': widget.branch.address,
      'guests': countControllerValue
    };
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reserved your table successfully, Enjoy!'),
      ),
    );

    await reservationsCollection.add(reservation).then((value) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserReservationsWidget(),
            ),
          )
        });
  }
}
