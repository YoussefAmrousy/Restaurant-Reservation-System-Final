// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:reservy/Admin/Screens/admin_branches_list/branches_list.dart';
import 'package:reservy/Admin/Screens/admin_restaurant_list/admin_restaurants_list.dart';
import 'package:reservy/Admin/Screens/restaurant_creation.dart';
import 'package:reservy/Utils/util.dart';
import 'package:reservy/models/restaurant.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key, required this.restaurant});
  final Restaurant restaurant;
  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  String? logoPath;

  @override
  void initState() {
    super.initState();
    logoPath = widget.restaurant.logoPath!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(
            widget.restaurant.name!,
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          backgroundColor: Color(0xC1E7AF2F),
          elevation: 12,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurtantsListScreen(),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantCreationScreen(
                      restaurant: widget.restaurant,
                    ),
                  ),
                );

                setState(() {
                  logoPath = widget.restaurant.logoPath!;
                });
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromRGBO(236, 235, 235, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(231, 66, 20, 4),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: 190.0,
                    height: 190.0,
                    child: logoPath != null
                        ? Image.network(
                            logoPath!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              'Logo Here',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    readOnly: true,
                    controller:
                        TextEditingController(text: widget.restaurant.name),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Cuisine',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                        text: Util.capitalize(widget.restaurant.cuisine!)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Popular Food',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                        text: widget.restaurant.popularFood),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    readOnly: true,
                    controller:
                        TextEditingController(text: widget.restaurant.phone),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Social Media',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                        text: widget.restaurant.socialMedia),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Website',
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    readOnly: true,
                    controller:
                        TextEditingController(text: widget.restaurant.website),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BranchesListScreen(
                                  restaurant: widget.restaurant),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Manage Branches',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xC1E7AF2F),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
