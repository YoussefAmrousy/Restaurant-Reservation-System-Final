// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:ui';
import 'package:flutter/material.dart';

class MenuTabWidget extends StatelessWidget {
  MenuTabWidget({super.key, required this.menuPath});
  String menuPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Blurred background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ), // Large image
                  SizedBox(
                      width: 320,
                      height: 600,
                      child: menuPath.isNotEmpty
                          ? Image.network(
                              menuPath,
                              fit: BoxFit.cover,
                            )
                          : Text('Menu Unavilable')),
                ],
              ),
            );
          },
        );
      },
      child: menuPath.isNotEmpty
          ? SizedBox(
              width: 50,
              height: 50,
              child: Image.network(menuPath),
            )
          : SizedBox(
              width: 50,
              height: 50,
              child: Text('Menu Unavilable'),
            ),
    );
  }
}
