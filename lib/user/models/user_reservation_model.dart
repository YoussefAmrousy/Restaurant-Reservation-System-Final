// ignore_for_file: unused_field

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/user/Screens/reservations.dart' show UserReservationsWidget;

class UserReservationsModel extends FlutterFlowModel<UserReservationsWidget> {
  final unfocusNode = FocusNode();


  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

}
