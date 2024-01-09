// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:reservy/Admin/Screens/admin_restaurant_list/admin_restaurants_list.dart';
import 'package:reservy/models/restaurant.dart';

class RestaurantCreatedDialog extends StatelessWidget {
  RestaurantCreatedDialog({super.key, this.restaurant});
  Restaurant? restaurant;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          restaurant != null ? 'Restaurant Updated' : 'Restaurant Created'),
      content: Text(restaurant != null
          ? 'The restaurant has been updated successfully.'
          : 'The restaurant has been created successfully.'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurtantsListScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
