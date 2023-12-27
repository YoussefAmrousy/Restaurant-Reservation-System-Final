// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/Services/auth_service.dart';
import 'package:restaurant_reservation_final/Services/reservations_service.dart';
import 'package:restaurant_reservation_final/models/reservation.dart';
import 'package:restaurant_reservation_final/user/Screens/restaurant_details.dart';
import 'package:restaurant_reservation_final/user/Screens/user_navigation_bar.dart';

class ReservyModel extends FlutterFlowModel<ReservyWidget> {
  final unfocusNode = FocusNode();
  double? ratingBarValue;
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  int countControllerValue = 0;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  DateTime? selectedDate;
  CollectionReference reservationsCollection =
      FirebaseFirestore.instance.collection('reservations');
  AuthService authService = AuthService();
  ReservationsService reservationsService = ReservationsService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }

  bool validateForm() {
    if (dropDownValue == null ||
        dropDownValue!.isEmpty ||
        selectedDate == null) {
      return false;
    }
    return true;
  }

  reserve(BuildContext context) async {
    if (countControllerValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must select number of guests'),
        ),
      );
      return false;
    }

    User currentUser = FirebaseAuth.instance.currentUser!;
    var userData = await authService.getUserData(currentUser.uid);

    if (userData.username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must complete your profile first'),
        ),
      );
      return false;
    }

    Reservation reservation = Reservation(
        userId: currentUser.uid,
        username: userData.username!,
        restaurant: widget.branch.restaurantName,
        date: selectedDate!,
        time: dropDownValue!,
        branch: widget.branch.address!,
        guests: countControllerValue);

    showLoadingIndicator(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reserved your table successfully, Enjoy!'),
      ),
    );

    await reservationsService.addReservation(reservation).then((value) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserNavigationBar(
                selectedIndex: 1,
              ),
            ),
          )
        });
  }

  void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Loading'),
            ],
          ),
        );
      },
    );
  }
}
