import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/main.dart';
import 'package:barangay_repository_app/widgets/containers/auth/register/verification_sent_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginFunctions {
  String? _email;
  String? _password;
  FirebaseQuery? _firebaseQuery;
  BuildContext? _context;
  FirebaseAuth? _auth;

  LoginFunctions(String email, String password, FirebaseQuery firebaseQuery,
      BuildContext context) {
    _email = email;
    _password = password;
    _firebaseQuery = firebaseQuery;
    _context = context;
  }

  Future<bool> loginAcount() async {
    bool returnFlag = false;
    await _firebaseQuery!
        .signInWithEmailAndPassword(_email!, _password!)
        .then((value) {
      if (value == null) {
        Alert(
            context: _context!,
            type: AlertType.error,
            desc: "Email or Password is incorrect.",
            closeFunction: null,
            buttons: [
              DialogButton(
                  onPressed: (() {
                    Navigator.pop(_context!);
                    returnFlag = false;
                  }),
                  child: const Text('OK'))
            ]).show();
      } else {
        returnFlag = true;
        // Alert(
        //     context: _context!,
        //     type: AlertType.success,
        //     desc: "Successfully Login.",
        //     closeFunction: null,
        //     buttons: [
        //       DialogButton(
        //           onPressed: (() => Navigator.pop(_context!)),
        //           child: const Text('OK'))
        //     ]).show().then((value) {
        //   Navigator.push(
        //       _context!, MaterialPageRoute(builder: (context) => _navigator!));
        // });
      }
    });

    return returnFlag;
  }
}
