// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AccountsListScreen extends StatefulWidget {
  const AccountsListScreen({super.key});

  @override
  _AccountsListState createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants Accounts'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Text('Restaurant'),
                    ),
                    TableCell(
                      child: Text('Email'),
                    ),
                    TableCell(
                      child: Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
