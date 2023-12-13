// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login_functions.dart';
import 'package:barangay_repository_app/widgets/containers/auth/register/register_functions.dart';
import 'package:barangay_repository_app/widgets/containers/auth/register/verification_sent_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:barangay_repository_app/widgets/core/core_button/core_button.dart';
import 'package:barangay_repository_app/widgets/core/core_textfield/core_textfield.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController suffixNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController precintNumberController = TextEditingController();
  TextEditingController lengthOfStayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseQuery firebaseQuery = FirebaseQuery();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    firebaseQuery.main();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    suffixNameController.dispose();
    addressController.dispose();
    precintNumberController.dispose();
    lengthOfStayController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator(), // Add CircularProgressIndicator widget here
                      )
                    : Container(),
                Text(
                  'Register your account here',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: CoreTextfield(
                        labelText: 'First Name',
                        controller: firstNameController,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: 70,
                      child: CoreTextfield(
                        labelText: 'M.I.',
                        controller: middleNameController,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: CoreTextfield(
                        labelText: 'Last Name',
                        controller: lastNameController,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: 70,
                      child: CoreTextfield(
                        fontSize: 15,
                        labelText: 'Suffix',
                        controller: suffixNameController,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: CoreTextfield(
                        labelText: 'Email',
                        controller: emailController,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: 70,
                      child: CoreTextfield(
                        fontSize: 15,
                        labelText: 'Age',
                        controller: ageController,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                CoreTextfield(
                  labelText: 'Address',
                  controller: addressController,
                ),
                SizedBox(
                  height: 16,
                ),
                CoreTextfield(
                  labelText: 'Precint Number',
                  controller: precintNumberController,
                ),
                SizedBox(
                  height: 16,
                ),
                CoreTextfield(
                  labelText: 'Length of stay in San Nicolas',
                  controller: lengthOfStayController,
                ),
                SizedBox(height: 16.0),
                CoreTextfield(
                  labelText: 'Password',
                  obscureText: true,
                  controller: passwordController,
                ),
                SizedBox(
                  height: 16,
                ),
                CoreTextfield(
                  labelText: 'Confirm Password',
                  obscureText: true,
                  controller: confirmPasswordController,
                ),
                SizedBox(height: 16),
                CoreButton(
                    text: 'Register',
                    onPressed: (() {
                      setState(() {
                        isLoading = true;
                      });
                      if (passwordController.text != '' &&
                          confirmPasswordController.text != '') {
                        RegisterFunctions registerFunctions = RegisterFunctions(
                          emailController.text,
                          passwordController.text,
                          RegisterFunctions.nameConcat(
                            firstNameController.text, 
                            middleNameController.text,
                            lastNameController.text,
                            suffixNameController.text
                          ),
                          firebaseQuery,
                          context,
                          ageController.text
                        );

                        registerFunctions.registerAcount().then((value) {
                          print('value: $value');

                          if (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                            firebaseQuery
                                .setUserCredentials(
                                    precintNumberController.text,
                                    lengthOfStayController.text,
                                    addressController.text,
                                    RegisterFunctions.nameConcat(
                                      firstNameController.text, 
                                      middleNameController.text,
                                      lastNameController.text,
                                      suffixNameController.text
                                    ),
                                    firebaseAuth.currentUser?.uid, 
                                    ageController.text)
                                .then((credentialValue) {
                              if (credentialValue) {
                                setState(() {
                                  isLoading = false;
                                });
                                firebaseAuth.signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              }
                            });
                          }
                        });
                      } else {
                        Alert(
                            context: context,
                            type: AlertType.error,
                            desc: "Password and Confirm Password not Matched.",
                            closeFunction: null,
                            closeIcon: null,
                            buttons: [
                              DialogButton(
                                  onPressed: (() => Navigator.pop(context)),
                                  child: const Text('OK'))
                            ]).show();
                      }
                    })),
                TextButton(
                    onPressed: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }),
                    child: Text('Already have an account? Sign-In instead'))
              ],
            )),
          )),
    );
  }
}
