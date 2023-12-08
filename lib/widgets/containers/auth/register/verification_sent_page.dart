// ignore_for_file: prefer_const_constructors

import 'package:barangay_repository_app/widgets/containers/auth/login/login.dart';
import 'package:flutter/material.dart';

class VerificationSentPage extends StatelessWidget {
  const VerificationSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                'Verification Email Sent',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Please check your email to verify your account.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle button press, e.g., navigate back to login page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
        ));
  }
}
