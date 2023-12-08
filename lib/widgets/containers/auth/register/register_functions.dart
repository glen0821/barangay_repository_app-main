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

  RegisterFunctions(String email, String password, String fullName,
      FirebaseQuery firebaseQuery, BuildContext context) {
    _email = email;
    _password = password;
    _fullName = fullName;
    _firebaseQuery = firebaseQuery;
    _context = context;
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
}
