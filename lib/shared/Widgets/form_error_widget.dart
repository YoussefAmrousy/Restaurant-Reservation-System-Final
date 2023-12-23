// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class FormErrorWidget extends StatelessWidget {
  FormErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      child: const Text(
        'Please fill out all required fields',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
