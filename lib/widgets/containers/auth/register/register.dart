// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:intl/intl.dart';
import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login.dart';
import 'package:barangay_repository_app/widgets/containers/auth/login/login_functions.dart';
import 'package:barangay_repository_app/widgets/containers/auth/register/register_functions.dart';
import 'package:barangay_repository_app/widgets/containers/auth/register/verification_sent_page.dart';
import 'package:barangay_repository_app/widgets/core/core_calendar/core_calendar.dart';
import 'package:barangay_repository_app/widgets/core/core_datefield/core_calendarfield.dart';
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
  TextEditingController birthDateController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseQuery firebaseQuery = FirebaseQuery();
  bool isLoading = false;
  bool _passVisible = false;
  bool _confirmpassVisible = false;

  // Length, Capital, Number
  final List<Color> _passTips = [Colors.red, Colors.red, Colors.red];

  static const List<String> allCivilStatus = ["Single", "Married", "Widowed", "Divorced"];
  String? civilStatus;

  // No color = 0, Red = 1, Orange = 2, Green = 3
  int _passStatus = 0;
  int _confirmPassStatus = 0;

  @override
  void initState() {
    super.initState();
    firebaseQuery.main();
  }

  void ageCalc() {
    String birthDateText = birthDateController.text;

    if (birthDateText.isNotEmpty) {
      try {
        DateTime birthDate = DateFormat("MM/dd/yyyy").parse(birthDateText);
        int age = AgeCalculator.calculateAge(birthDate);

        setState(() {
          ageController.text = age.toString();
        });
      } catch (e) {
        print(e);
      }
    }
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
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
                              enabled: false,
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
                      CoreDateField(
                        labelText: 'Birth Date',
                        controller: birthDateController,
                        onDateChanged: (DateTime newDate) {
                          ageCalc();
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 58,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(5))
                        ),
                        alignment: Alignment.center,
                        child: DropdownButton(
                          value: civilStatus,
                          items: allCivilStatus.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );}
                          ).toList(),
                          hint: Text("Civil Status"),
                          onChanged: (value) => {
                            setState(() {
                              civilStatus = value;
                            })
                          },
                          isExpanded: true,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          underline: Container(height: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 7.8),
                        ),
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
                      Column(
                        children: [
                          TextField(
                            obscureText: !_passVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_passVisible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => {
                                  setState(() {_passVisible = !_passVisible;})
                                },
                              )
                            ),
                            onChanged: (String text) {
                              setState(() {
                                _passTips[1] = RegExp(r"[A-Z]").hasMatch(text) ? Colors.green : Colors.red;
                                _passTips[2] = RegExp(r"[0-9]").hasMatch(text) ? Colors.green : Colors.red;

                                if (text.isEmpty) {
                                  _passTips[0] = Colors.red;
                                  _passStatus = 0;
                                } else if (text.length <= 7) {
                                  _passTips[0] = Colors.red;
                                  _passStatus = 1;
                                } else if (text.length < 12) {
                                  _passStatus = 2;
                                  _passTips[0] = Colors.green;
                                } else {
                                  _passTips[0] = Colors.green;
                                  _passStatus = 3;
                                }

                                if (confirmPasswordController.text.isEmpty) {
                                  _confirmPassStatus = 0;
                                } else if (_passStatus <= 1 || confirmPasswordController.text != text) {
                                  _confirmPassStatus = 1;
                                } else {
                                  _confirmPassStatus = 3;
                                }
                              });
                            },
                            controller: passwordController,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: RegisterFunctions.passColor(_passStatus, _passStatus)
                            ),
                            height: 4,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: [
                          TextField(
                            obscureText: !_confirmpassVisible,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_confirmpassVisible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => {
                                  setState(() {_confirmpassVisible = !_confirmpassVisible;})
                                }
                              )
                            ),
                            onChanged: (String text) {
                              setState(() {
                                if (text.isEmpty) {
                                  _confirmPassStatus = 0;
                                } else if (text != passwordController.text) {
                                  _confirmPassStatus = 1;
                                } else {
                                  _confirmPassStatus = 3;
                                }
                              });
                            },
                            controller: confirmPasswordController,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: RegisterFunctions.passColor(_confirmPassStatus, _passStatus)
                            ),
                            height: 4,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 406,
                        child: Text(
                          "• Password must be 8 characters long",
                          style: TextStyle(
                            color: _passTips[0]
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 406,
                        child: Text(
                          "• Password must have a capital letter",
                          style: TextStyle(
                            color: _passTips[1]
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 406,
                        child: Text(
                          "• Password must have a number",
                          style: TextStyle(
                            color: _passTips[2]
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
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
                                ageController.text,
                                birthDateController.text,
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
                                          ageController.text,
                                      birthDateController.text)
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
                  ),
                )),
          )),
    );
  }
}

class AgeCalculator {
  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    // Adjust age if the birthday hasn't occurred yet this year
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}

