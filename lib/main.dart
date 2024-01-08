// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:reservy/Admin/Screens/admin_restaurant_list/admin_restaurants_list.dart';
import 'package:reservy/Restaurant/restaurant_reservations.dart';
import 'package:reservy/Screens/login_screen.dart';
import 'package:reservy/Services/auth_service.dart';
import 'package:reservy/providers/location_provider.dart';
import 'package:reservy/user/Screens/user_reservations.dart';
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
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFFFF8313,
          {
            50: Color(0xFFFFF3E0),
            100: Color(0xFFFFE0B2),
            200: Color(0xFFFFCC80),
            300: Color(0xFFFFB74D),
            400: Color(0xFFFFA726),
            500: Color(0xFFFF9800),
            600: Color(0xFFFB8C00),
            700: Color(0xFFF57C00),
            800: Color(0xFFEF6C00),
            900: Color(0xFFE65100),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: islogin ? UserReservationsWidget() : LoginScreen(),
    );
  }
}
