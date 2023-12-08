// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';
import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login.dart';
import 'package:barangay_repository_app/widgets/containers/pages/tabs/main_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseQuery firebaseQuery = FirebaseQuery();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    firebaseQuery.main();
    // Simulating a delay for demonstration purposes
    Timer(Duration(seconds: 3), () {
      // Replace this with your actual app's home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                _auth.currentUser == null ? LoginPage() : MainTab()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize the background color if needed
      body: Center(
        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.asset(
                            'assets/sn3.png',
                          ),
                        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LoginPage(),
//     );
//   }
// }
