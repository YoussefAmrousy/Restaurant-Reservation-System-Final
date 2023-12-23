// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_reservation_final/Admin/Screens/restaurantList/restaurants_list.dart';
import 'package:restaurant_reservation_final/Services/firebase_storage_service.dart';
import 'package:restaurant_reservation_final/enums/cuisine_enum.dart';
import 'package:restaurant_reservation_final/models/restaurant.dart';
import 'package:restaurant_reservation_final/shared/Widgets/form_error_widget.dart';

class RestaurantCreationScreen extends StatefulWidget {
  const RestaurantCreationScreen({super.key, this.restaurant});
  final Restaurant? restaurant;

  @override
  _RestaurantCreationScreenState createState() =>
      _RestaurantCreationScreenState();
}

class _RestaurantCreationScreenState extends State<RestaurantCreationScreen> {
  final formKey = GlobalKey<FormState>();
  bool showError = false;
  final restaurantNameController = TextEditingController();
  final phoneController = TextEditingController();
  final socialMediaController = TextEditingController();
  final websiteController = TextEditingController();
  Cuisine? selectedCuisine = Cuisine.selectCuisine;
  File? logo;
  File? menu;
  final picker = ImagePicker();
  List<Cuisine> cuisineList = Cuisine.values;

  CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('restaurants');
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  @override
  void initState() {
    super.initState();
    initRestaurant();
  }

  initRestaurant() {
    if (widget.restaurant != null) {
      restaurantNameController.text = widget.restaurant!.name;
      selectedCuisine = Cuisine.values
          .firstWhere((element) => element.value == widget.restaurant!.cuisine);
    }
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    var file = File(pickedFile.path);
    setState(() {
      logo = file;
    });
  }

  Future<String?> getMenu() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null;
    }

    var file = File(pickedFile.path);
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    setState(() {
      menu = file;
    });

    await storageReference.putFile(file);
    return await storageReference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(widget.restaurant != null
              ? 'Restaurant Updated'
              : 'Restaurant Created'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(widget.restaurant != null
                    ? 'The restaurant has been updated successfully.'
                    : 'The restaurant has been created successfully.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
        ),
      );
    }

    bool validateForm() {
      if (logo == null ||
          restaurantNameController.text.trim().isEmpty ||
          selectedCuisine == Cuisine.selectCuisine ||
          !formKey.currentState!.validate()) {
        return false;
      } else {
        return true;
      }
    }

    Future<void> submitRestaurant() async {
      if (widget.restaurant != null) {
        final restaurantQuery = await restaurantsCollection
            .where('name', isEqualTo: widget.restaurant!.name)
            .get();
        if (restaurantQuery.docs.isNotEmpty) {
          final restaurantFound = restaurantQuery.docs.first;
          await restaurantFound.reference.update({
            'name': restaurantNameController.text,
            'cuisine': selectedCuisine!.value,
            'phone': phoneController.text,
            'socialMedia': socialMediaController.text,
            'website': websiteController.text,
            'menu': menu?.path,
          });
        }
        showMyDialog();
        return;
      }

      final restaurant = {
        'name': restaurantNameController.text,
        'cuisine': selectedCuisine!.value,
        'phone': phoneController.text,
        'socialMedia': socialMediaController.text,
        'website': websiteController.text,
        'isActive': true,
        'menu': menu?.path,
      };

      firebaseStorageService.uploadImage(imageToUpload: File(logo!.path), title: restaurantNameController.text);


      final existingRestaurant = await restaurantsCollection
          .where('name', isEqualTo: restaurantNameController.text)
          .get();

      if (existingRestaurant.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restaurant already exists'),
          ),
        );
        return;
      }

      restaurantsCollection.add(restaurant);
      showMyDialog();
      formKey.currentState!.reset();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(236, 235, 235, 1),
        title: Text(
          widget.restaurant != null
              ? 'Edit ${widget.restaurant!.name}'
              : 'Create Restaurant',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showError) FormErrorWidget(),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
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
                                    width: 200.0,
                                    height: 200.0,
                                    child: logo != null
                                        ? Image.file(
                                            logo!,
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
                                    width: 200.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showError = false;
                                          getImage();
                                        });
                                      },
                                      child: const Text(
                                        'Upload Logo',
                                        style: TextStyle(
                                          color: Color(0xFFECEBEB),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
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
                                    width: 200.0,
                                    height: 200.0,
                                    child: menu != null
                                        ? Image.file(
                                            menu!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Text(
                                              'Menu Here',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 200.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showError = false;
                                          getMenu();
                                        });
                                      },
                                      child: const Text(
                                        'Upload Menu',
                                        style: TextStyle(
                                          color: Color(0xFFECEBEB),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: restaurantNameController,
                          decoration: InputDecoration(
                            labelText: 'Restaurant Name',
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButton<Cuisine>(
                          value: selectedCuisine,
                          onChanged: (Cuisine? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedCuisine = newValue;
                              });
                            }
                          },
                          items: cuisineList.map((Cuisine cuisine) {
                            return DropdownMenuItem<Cuisine>(
                              value: cuisine,
                              child: Text(cuisine.name),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: phoneController,
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
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: socialMediaController,
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
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: websiteController,
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
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              final validForm = validateForm();

                              setState(() {
                                showError = !validForm;
                              });

                              if (validForm) {
                                submitRestaurant();
                              }
                            },
                            child: Text(
                              widget.restaurant != null
                                  ? 'Update Restaurant'
                                  : 'Create Restaurant',
                              style: TextStyle(
                                color: Color(0xFFECEBEB),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
