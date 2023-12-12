import 'dart:convert';

import 'package:barangay_repository_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class FirebaseQuery {
  // FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
  }

  bool authStateChanges() {
    bool flag = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  bool idTokenChanges() {
    bool flag = false;
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        flag = false;
      } else {
        flag = true;
      }
    });

    return flag;
  }

  bool userChanges() {
    bool flag = false;
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<int> createUserWithEmailAndPassword(
      String email, String password, String fullName) async {
    int stringThrow = 0;
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await value.user?.updateDisplayName(fullName);
        stringThrow = 1;
        await FirebaseAuth.instance.setLanguageCode("en");
        await value.user?.sendEmailVerification();
        if (kDebugMode) {
          print(value.user);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        stringThrow = 2;
      } else if (e.code == 'email-already-in-use') {
        stringThrow = 3;
      }
    } catch (e) {
      stringThrow = 4;
      print(e);
    }

    return stringThrow;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    User? userReturn;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(((value) {
        print(value.user);
        userReturn = value.user;
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return userReturn;
  }

  Future<void> updateProfile(String name, String lengthOfStay,
      String precintNumber, String address, User? user) async {
    await user?.updateDisplayName(name);
    await updateUserOtherCredentials(
        name, lengthOfStay, precintNumber, address, user!.uid.toString());
  }

  //---------------------------- FIRESTORE QUERIES ------------------------------------//

  Future<Map<String, dynamic>> getUserCredentials(String documentId) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    final docRef = firestoreDB.collection("votersList").doc(documentId);
    var snapshot = await docRef.get();
    return snapshot.data() as Map<String, dynamic>;
    // ...
  }

  Future<bool> setUserCredentials(
    String precint_number,
    String length_of_stay,
    String address,
    String fullName,
    String? docId,
  ) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    bool returnFlag = false;
    DateTime currentTime = DateTime.now();
    // int epochTime = currentTime.millisecondsSinceEpoch;
    final credentials = <String, dynamic>{
      "completeName": fullName,
      "precintNumber": precint_number,
      "lengthOfStay": length_of_stay,
      "completeAddress": address,
      "createdAt": currentTime,
    };
    firestoreDB
        .collection("votersList")
        .doc(docId)
        .set(credentials)
        .then((value) => returnFlag = true)
        .catchError((error) => print('error: $error'));
    return returnFlag;
  }

  Future<void> updateUserOtherCredentials(String name, String lengthOfStay,
      String precintNumber, String address, String documentId) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    DateTime currentTime = DateTime.now();

    final users = <String, dynamic>{
      "completeAddress": address,
      "completeName": name,
      "lengthOfStay": lengthOfStay,
      "precintNumber": precintNumber,
      "updatedAt": currentTime
    };

    final usersRef = firestoreDB.collection("votersList").doc(documentId);
    usersRef.update(users);

    // firestoreDB
    //     .collection("votersList")
    //     .doc(documentId)
    //     .set(users)
    //     .onError((e, _) => print("Error writing document: $e"));
  }

  // Future<void> appointOrRequestAppointment(
  //     Object data, String documentId) async {
  //   FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  //   final usersRef = firestoreDB.collection("votersList").doc(documentId);
  //   var snapshot = await usersRef.get();
  //   var dataSnap = snapshot.data() as Map<String, dynamic>;

  //   if (dataSnap['appointments'] != null) {
  //     var dataTemp = jsonDecode(dataSnap['appointments']);
  //     dataTemp.add(data);
  //     usersRef.update({"appointments": jsonEncode(dataTemp)});
  //   } else {
  //     usersRef.update({
  //       "appointments": jsonEncode([data])
  //     });
  //   }
  // }

  Future<bool> setCertificate(
    String userId,
    DateTime appointmentDate,
    String purpose,
  ) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    bool returnFlag = false;
    DateTime currentTime = DateTime.now();
    int epochTime = currentTime.millisecondsSinceEpoch;
    final docRef = firestoreDB.collection("votersList").doc(userId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final certificateDetails = <String, dynamic>{
          "completeName": data['completeName'],
          "lengthOfStay": data['lengthOfStay'],
          "dateOfAppointment": DateFormat('yyy-M-d').format(DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day)),
          "appointmentOwner": userId,
          "purpose": purpose,
          "address": data['completeAddress'],
          "createdAt": DateFormat("MMMM d, yyy 'at h:mm:ss a UTC+8").format(DateTime(currentTime.year, currentTime.month, currentTime.day, currentTime.hour, currentTime.minute, currentTime.second)),
        };
        firestoreDB
            .collection("barangayCertificate")
            .doc(epochTime.toString())
            .set(certificateDetails)
            .then((value) => returnFlag = true)
            .catchError((error) => print('error: $error'));
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return returnFlag;
  }

  Future<bool> setClearance(
    String userId,
    dynamic appointmentDate,
    String purpose,
  ) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    bool returnFlag = false;
    DateTime currentTime = DateTime.now();
    int epochTime = currentTime.millisecondsSinceEpoch;
    final docRef = firestoreDB.collection("votersList").doc(userId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final certificateDetails = <String, dynamic>{
          "completeName": data['completeName'],
          "bgyClearanceCounter": 1,
          "lengthOfStay": data['lengthOfStay'],
          "dateOfAppointment": DateFormat('yyy-M-d').format(DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day)),
          "appointmentOwner": userId,
          "purpose": purpose,
          "address": data['completeAddress'],
          "createdAt": DateFormat("MMMM d, yyy 'at h:mm:ss a UTC+8").format(DateTime(currentTime.year, currentTime.month, currentTime.day, currentTime.hour, currentTime.minute, currentTime.second)),
        };
        firestoreDB
            .collection("barangayClearance")
            .doc(epochTime.toString())
            .set(certificateDetails)
            .then((value) => returnFlag = true)
            .catchError((error) => print('error: $error'));
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return returnFlag;
  }

    Future<bool> setComplaint(
    String userId,
    DateTime appointmentDate,
    String complaint,
  ) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    bool returnFlag = false;
    DateTime currentTime = DateTime.now();
    int epochTime = currentTime.millisecondsSinceEpoch;
    final docRef = firestoreDB.collection("votersList").doc(userId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final certificateDetails = <String, dynamic>{
          "completeName": data['completeName'],
          "lengthOfStay": data['lengthOfStay'],
          "dateOfAppointment": DateFormat('yyy-M-d').format(DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day)),
          "appointmentOwner": userId,
          "complaint": complaint,
          "address": data['completeAddress'],
          "createdAt": DateFormat("MMMM d, yyy 'at h:mm:ss a UTC+8").format(DateTime(currentTime.year, currentTime.month, currentTime.day, currentTime.hour, currentTime.minute, currentTime.second)),
        };
        firestoreDB
            .collection("Complaints")
            .doc(epochTime.toString())
            .set(certificateDetails)
            .then((value) => returnFlag = true)
            .catchError((error) => print('error: $error'));
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return returnFlag;
  }

  Future<bool> setBrgID(
      String userId,
      dynamic appointmentDate,
      String sex,
      String age,
      String weight,
      String height,
      String amount,
      String transactionID,
      ) async {
      FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
      bool returnFlag = false;
      DateTime currentTime = DateTime.now();
      int epochTime = currentTime.millisecondsSinceEpoch;
      final docRef = firestoreDB.collection("votersList").doc(userId);

      docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final certificateDetails = <String, dynamic>{
          "completeName": data['completeName'],
          "address": data['completeAddress'],
          "lengthOfStay": data['lengthOfStay'],
          "bgyClearanceCounter": 1,
          "dateOfAppointment": DateFormat('yyy-M-d').format(
            DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day),
          ),
          "appointmentOwner": userId,
          "gender": sex,
          "age": age,
          "weight": weight,
          "height": height,
          "amountPaid": amount,
          "transactionId": transactionID,
          "transactionDate": currentTime.toUtc().toString(),
          "createdAt": DateFormat("MMMM d, yyy 'at h:mm:ss a UTC+8").format(
            DateTime(
              currentTime.year,
              currentTime.month,
              currentTime.day,
              currentTime.hour,
              currentTime.minute,
              currentTime.second,
            ),
          ),
        };
        firestoreDB
            .collection("barangayID")
            .doc(epochTime.toString())
            .set(certificateDetails)
            .then((value) => returnFlag = true)
            .catchError((error) => print('error: $error'));
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return returnFlag;
  }



  Future<void> logout(FirebaseAuth auth, Function(void) thenPress) async {
    try {
      await auth.signOut().then(
            thenPress,
          );
      // Optionally, perform any additional actions after signing out
    } catch (e) {
      print('Logout failed: $e');
      // Handle any errors that occur during logout
    }
  }
}
