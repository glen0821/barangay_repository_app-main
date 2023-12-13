import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterFunctions {
  String? _email;
  String? _password;
  String? _fullName;
  FirebaseQuery? _firebaseQuery;
  BuildContext? _context;
  Widget? _navigator;
  String? _age;

  RegisterFunctions(String email, String password, String fullName,
      FirebaseQuery firebaseQuery, BuildContext context, String age) {
    _email = email;
    _password = password;
    _fullName = fullName;
    _firebaseQuery = firebaseQuery;
    _context = context;
    _age = age;
  }
  Future<bool> registerAcount() async {
    bool returnFlag = false;
    await _firebaseQuery!
        .createUserWithEmailAndPassword(_email!, _password!, _fullName!)
        .then((value) {
      switch (value) {
        case 0:
          {
            Alert(
                context: _context!,
                type: AlertType.error,
                desc: "Invalid email format.",
                closeFunction: null,
                buttons: [
                  DialogButton(
                      onPressed: (() => Navigator.pop(_context!)),
                      child: const Text('OK'))
                ]).show();
            break;
          }
        case 1:
          {
            returnFlag = true;
            Alert(
                context: _context!,
                type: AlertType.success,
                desc: "Successfully registered.",
                closeFunction: null,
                closeIcon: null,
                buttons: [
                  DialogButton(
                      onPressed: (() => Navigator.pop(_context!)),
                      child: const Text('OK'))
                ]).show();
            break;
          }
        case 2:
          {
            Alert(
                context: _context!,
                type: AlertType.error,
                desc: "Password is weak.",
                closeFunction: null,
                buttons: [
                  DialogButton(
                      onPressed: (() => Navigator.pop(_context!)),
                      child: const Text('OK'))
                ]).show();
            break;
          }
        case 3:
          {
            Alert(
                context: _context!,
                type: AlertType.error,
                desc: "Email ${_email} is already in use.",
                closeFunction: null,
                buttons: [
                  DialogButton(
                      onPressed: (() => Navigator.pop(_context!)),
                      child: const Text('OK'))
                ]).show();
            break;
          }
        default:
          {
            Alert(
                context: _context!,
                type: AlertType.error,
                desc: "Something went wrong.....",
                closeFunction: null,
                buttons: [
                  DialogButton(
                      onPressed: (() => Navigator.pop(_context!)),
                      child: const Text('OK'))
                ]).show();
          }
      }
    });

    return returnFlag;
  }
  static String nameConcat(
    String firstName,
    String middleName,
    String lastName,
    String suffixName
  ) {
    return "$firstName $middleName $lastName $suffixName";
  }
  static Color passColor(int passStatus) {
    switch (passStatus) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
    }
    return Colors.white;
  }
  static Color passConfirmColor(int passStatus) {
    switch (passStatus) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
    }
    return Colors.white;
  }
}
