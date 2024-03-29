// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservy/Admin/Widgets/restaurant_created_dialog.dart';
import 'package:reservy/Enums/cuisine_enum.dart';
import 'package:reservy/Services/restaurant_service.dart';
import 'package:reservy/models/restaurant.dart';
import 'package:reservy/shared/Widgets/form_error_widget.dart';

class RestaurantCreationScreen extends StatefulWidget {
  RestaurantCreationScreen({super.key, this.restaurant});
  Restaurant? restaurant;

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
  final popularFoodController = TextEditingController();
  Cuisine? selectedCuisine = Cuisine.selectCuisine;
  String? logoPath;
  String? menuPath;
  List<Cuisine> cuisineList = Cuisine.values;
  final picker = ImagePicker();

  RestaurantService restaurantService = RestaurantService();

  @override
  void initState() {
    super.initState();
    initRestaurant();
  }

  initRestaurant() {
    if (widget.restaurant != null) {
      logoPath = widget.restaurant!.logoPath;
      menuPath = widget.restaurant!.menuPath;
      restaurantNameController.text = widget.restaurant!.name!;
      selectedCuisine = Cuisine.values.firstWhere((element) =>
          element.value.toLowerCase() ==
          widget.restaurant!.cuisine!.toLowerCase());
      phoneController.text = widget.restaurant!.phone!;
      socialMediaController.text = widget.restaurant!.socialMedia!;
      websiteController.text = widget.restaurant!.website!;
      popularFoodController.text = widget.restaurant!.popularFood!;
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      logoPath = pickedFile.path;
    });
  }

  Future<void> getMenu() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      menuPath = pickedFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool validateForm() {
      if (logoPath == null ||
          menuPath == null ||
          websiteController.text.trim().isEmpty ||
          socialMediaController.text.trim().isEmpty ||
          phoneController.text.trim().isEmpty ||
          restaurantNameController.text.trim().isEmpty ||
          selectedCuisine == Cuisine.selectCuisine ||
          popularFoodController.text.trim().isEmpty ||
          !formKey.currentState!.validate()) {
        return false;
      } else {
        return true;
      }
    }

    Future<void> submitRestaurant() async {
      final Restaurant restaurant = Restaurant(
          name: restaurantNameController.text,
          cuisine: selectedCuisine!.value,
          phone: phoneController.text,
          socialMedia: socialMediaController.text,
          website: websiteController.text,
          rating: 0,
          ratingCount: 0,
          popularFood: popularFoodController.text);

      if (widget.restaurant != null) {
        restaurant.logoPath = widget.restaurant!.logoPath;
        restaurant.menuPath = widget.restaurant!.menuPath;
        var restaurantUpdated =
            await restaurantService.updateRestaurant(restaurant);
        if (restaurantUpdated == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating restaurant'),
            ),
          );
          return;
        }
        RestaurantCreatedDialog(
          restaurant: restaurant,
        );
        return;
      }

      var restaurantCreation = await restaurantService.addRestaurant(
          restaurant, File(logoPath!), File(menuPath!));

      if (restaurantCreation == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restaurant already exists'),
          ),
        );
        return;
      }

      showDialog(
          context: context, builder: (context) => RestaurantCreatedDialog());
      formKey.currentState!.reset();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          backgroundColor: Color(0xC1E7AF2F),
          title: Text(
            widget.restaurant != null
                ? 'Edit ${widget.restaurant!.name}'
                : 'Create Restaurant',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          elevation: 12,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showError) FormErrorWidget(),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromARGB(231, 66, 20, 4),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    width: 150.0,
                                    height: 200.0,
                                    child: logoPath != null &&
                                            widget.restaurant != null
                                        ? Image.network(
                                            logoPath!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : logoPath != null
                                            ? Image.file(
                                                File(logoPath!),
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : Center(
                                                child: Text(
                                                  'Logo',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                  ),
                                  SizedBox(
                                    width: 150.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showError = false;
                                          getImage();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Upload Logo',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xC1E7AF2F),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromARGB(231, 66, 20, 4),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    width: 150.0,
                                    height: 200.0,
                                    child: menuPath != null &&
                                            widget.restaurant != null
                                        ? Image.network(
                                            menuPath!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : menuPath != null
                                            ? Image.file(
                                                File(menuPath!),
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
                                    width: 150.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showError = false;
                                          getMenu();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Upload Menu',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xC1E7AF2F),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
                        TextField(
                          controller: popularFoodController,
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
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
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
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
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
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Color(0xC1E7AF2F),
                                    fontWeight: FontWeight.bold,
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
