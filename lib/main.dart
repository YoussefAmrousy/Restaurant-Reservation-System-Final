// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:reservy/Admin/Screens/admin_restaurant_list/admin_restaurants_list.dart';
import 'package:reservy/Restaurant/restaurant_reservations.dart';
import 'package:reservy/Screens/login_screen.dart';
import 'package:reservy/providers/location_provider.dart';
import 'package:reservy/shared/Utils/check_internet_connection.dart';
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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var islogin = false;

  checkiflogin() async {
    await InternetConnection.checkInternetConnection();
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          islogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkiflogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/reservations': (context) => ReservationsWidget(),
        '/restaurants': (context) => RestaurtantsListScreen(),
        '/login': (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: islogin && InternetConnection.isInternetConnected == false
          ? UserNavigationBar(
              selectedIndex: 1,
            )
          : LoginScreen(),
    );
  }
}
