// ignore_for_file: unused_field

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/models/reservation.dart';
import 'package:restaurant_reservation_final/user/reservations.dart' show UserReservationsWidget;

class UserReservationsModel extends FlutterFlowModel<UserReservationsWidget> {
  ///  State fields for stateful widgets in this page.
  List<Reservation> _userReservations = [];
  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  void setUserReservations(List<Reservation> userReservations) {
    _userReservations = userReservations;
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
