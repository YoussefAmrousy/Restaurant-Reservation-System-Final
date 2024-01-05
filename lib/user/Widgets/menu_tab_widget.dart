// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:flutter/material.dart';

class MenuTabWidget extends StatelessWidget {
  MenuTabWidget({super.key, required this.menuPath});
  String menuPath;

  @override
  Widget build(BuildContext context) {
    return menuPath.isNotEmpty
        ? SizedBox(
            width: 50,
            height: 50,
            child: Image.network(menuPath),
          )
        : SizedBox(
            width: 50,
            height: 50,
            child: Text('Menu Unavilable'),
          );
  }
}
