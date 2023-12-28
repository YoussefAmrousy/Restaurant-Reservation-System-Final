// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_reservation_final/Admin/Screens/admin_branches_list/branches_list.dart';
import 'package:restaurant_reservation_final/Maps/map_screen.dart';
import 'package:restaurant_reservation_final/models/branch.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';
import 'package:restaurant_reservation_final/providers/location_provider.dart';
import 'package:restaurant_reservation_final/shared/Widgets/form_error_widget.dart';

class BranchCreationScreen extends StatefulWidget {
  const BranchCreationScreen({super.key, this.branch, this.restaurant});
  final Branch? branch;
  final Restaurant? restaurant;

  @override
  _BranchCreationScreenState createState() => _BranchCreationScreenState();
}

class _BranchCreationScreenState extends State<BranchCreationScreen> {
  final branchNameController = TextEditingController();
  final restaurantNameController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  LocationProvider? locationProvider;

  CollectionReference branchesCollection =
      FirebaseFirestore.instance.collection('branches');

  bool showError = false;

  @override
  void initState() {
    super.initState();
    if (widget.restaurant != null) {
      restaurantNameController.text = widget.restaurant!.name!;
    }
  }

  bool validateForm() {
    if (widget.restaurant == null ||
        branchNameController.text.trim().isEmpty ||
        restaurantNameController.text.trim().isEmpty ||
        areaController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        !formKey.currentState!.validate()) {
      return false;
    } else {
      return true;
    }
  }

  submitBranch() async {
    LatLng? selectedLocation = locationProvider?.selectedLocation;
    final branch = {
      'name': branchNameController.text.trim(),
      'restaurant': restaurantNameController.text.trim(),
      'area': areaController.text.trim(),
      'city': cityController.text.trim(),
      'address': addressController.text.trim(),
      'phone': phoneController.text.trim(),
      'longitude': selectedLocation?.longitude,
      'latitude': selectedLocation?.latitude,
      'cuisine': widget.restaurant?.cuisine,
    };

    final exisitingBranch = await branchesCollection
        .where('address', isEqualTo: branch['address'])
        .get();
    if (exisitingBranch.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Branch already exists'),
        ),
      );
      return;
    }
    addBranch(branch);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Branch created successfully'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BranchesListScreen(restaurant: widget.restaurant!),
      ),
    );
  }

  addBranch(branch) {
    branchesCollection.add(branch);
    formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.branch != null
              ? 'Edit ${widget.branch!.name}'
              : 'Create Branch',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BranchesListScreen(
                  restaurant: widget.restaurant!,
                ),
              ),
            );
          },
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(236, 235, 235, 1),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  if (showError) FormErrorWidget(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextField(
                            decoration: InputDecoration(
                              labelText: 'Branch Name',
                              border: OutlineInputBorder(),
                            ),
                            controller: branchNameController),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Restaurant Name',
                            border: OutlineInputBorder(),
                          ),
                          controller: restaurantNameController,
                          enabled: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                            decoration: InputDecoration(
                              labelText: 'Area',
                              border: OutlineInputBorder(),
                            ),
                            controller: areaController),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                            decoration: InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                            controller: cityController),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                            decoration: InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                            controller: addressController),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                            ),
                            controller: phoneController),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 150,
                          child: MapScreen(
                            allowMarkerSelection: true,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final validForm = validateForm();
                            if (validForm) {
                              submitBranch();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            widget.branch != null
                                ? 'Edit Branch'
                                : 'Create Branch',
                            style: TextStyle(
                              color: Color(0xFFECEBEB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
