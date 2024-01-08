// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:reservy/Admin/Screens/admin_restaurant_list/admin_restaurants_list.dart';
import 'package:reservy/Screens/login_screen.dart';
import 'package:reservy/Services/shared_preference_service.dart';
import 'package:reservy/providers/location_provider.dart';
import 'package:reservy/user/Screens/user_navigation_bar.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;

  getLoggedInState() async {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
    await sharedPreferenceService
        .getStringFromLocalStorage('loggedIn')
        .then((value) {
      setState(() {
        userIsLoggedIn = value == 'true' ? true : false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/restaurants': (context) => RestaurtantsListScreen(),
        '/login': (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return userIsLoggedIn != null
                ? UserNavigationBar(
                    selectedIndex: 0,
                  )
                : LoginScreen();
          } else {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
