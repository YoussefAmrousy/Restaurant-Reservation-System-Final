import 'package:flutterflow_ui/flutterflow_ui.dart' show FlutterFlowModel;
import 'package:flutter/material.dart';
import 'package:reservy/Restaurant/restaurant_reservations.dart';

class ReservationsModel extends FlutterFlowModel<ReservationsWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
