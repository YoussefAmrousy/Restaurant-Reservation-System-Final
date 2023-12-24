// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_final/Restaurant/restaurant_navigation_bar.dart';
import 'package:restaurant_reservation_final/Screens/register_screen.dart';
import 'package:restaurant_reservation_final/Admin/Screens/admin_navbar.dart';
import 'package:restaurant_reservation_final/Services/auth_service.dart';
import 'package:restaurant_reservation_final/user/user_navigation_bar.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final coolGrey = const Color.fromARGB(255, 169, 169, 169);

  submit() async {
    final form = _formKey.currentState;
    AuthService authService = AuthService();
    if (form!.validate()) {
      form.save();
      User? user = await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      String? userRole = await authService.getUserRole(user!.uid);
      if (userRole == 'admin') {
        _navigateToRoleSpecificScreen('admin');
      } else if (userRole == 'restaurant') {
        _navigateToRoleSpecificScreen('restaurant');
      } else {
        _navigateToRoleSpecificScreen('user');
      }
        }
  }

  void _navigateToRoleSpecificScreen(String role) {
    switch (role) {
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminNavigationBar()),
        );
        break;
      case 'restaurant':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RestaurantNavigationBar()),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserNavigationBar()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 320,
                    height: 60,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    height: 100,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        helperText: 'Minimum length is 5 charcters',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        submit();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(coolGrey),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: const Text("Create an account"),
            ),
          ],
        ),
      ),
    );
  }
}
