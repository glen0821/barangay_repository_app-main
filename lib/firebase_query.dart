import 'dart:convert';

import 'package:barangay_repository_app/main.dart';
import 'package:barangay_repository_app/widgets/core/core_calendar/core_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  Future<void> updateProfile(
      String firstName,
      String lastName,
      String middleInitial,
      String suffixName,
      String lengthOfStay,
      String precintNumber,
      String address,
      User? user,
      String age) async {
    await user
        ?.updateDisplayName("$firstName $lastName $middleInitial. $suffixName");
    await updateUserOtherCredentials(
        "$firstName $lastName $middleInitial. $suffixName",
        firstName,
        lastName,
        middleInitial,
        suffixName,
        lengthOfStay,
        precintNumber,
        address,
        user!.uid.toString(),
        age);
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
      String age,
      String birthDate,
      String firstName,
      String lastName,
      String middleInitial,
      String suffixName,
      String gender,
      String civilStatus,
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
      "age": age,
      "birthDate": birthDate,
      "firstName": firstName,
      "lastName": lastName,
      "middleInitial": middleInitial,
      "suffixName": suffixName,
      "gender": gender,
      "civilStatus": civilStatus
    };
    firestoreDB
        .collection("votersList")
        .doc(docId)
        .set(credentials)
        .then((value) => returnFlag = true)
        .catchError((error) => debugPrint('error: $error'));
    return returnFlag;
  }
  Future<void> updateUserOtherCredentials(
      String name,
      String firstName,
      String lastName,
      String middleInitial,
      String suffixName,
      String lengthOfStay,
      String precintNumber,
      String address,
      String documentId,
      String age) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    DateTime currentTime = DateTime.now();

    final users = <String, dynamic>{
      "completeAddress": address,
      "completeName": name,
      "firstName": firstName,
      "lastName": lastName,
      "middleInitial": middleInitial,
      "suffixName": suffixName,
      "lengthOfStay": lengthOfStay,
      "precintNumber": precintNumber,
      "updatedAt": currentTime,
      "age": age
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
      String quantity
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
          "status": "Processing",
          "address": data['completeAddress'],
          "createdAt": DateFormat("yyyy-M-d").format(
            DateTime(
              currentTime.year,
              currentTime.month,
              currentTime.day,
              // currentTime.hour,
              // currentTime.minute,
              // currentTime.second,
            ),
          ),
          "quantity": quantity,
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
      String quantity
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
          "status": "Processing",
          "address": data['completeAddress'],
          "createdAt": DateFormat("yyyy-M-d").format(
              DateTime(
                currentTime.year,
                currentTime.month,
                currentTime.day,
                // currentTime.hour,
                // currentTime.minute,
                // currentTime.second,
              )
          ),
          "quantity": quantity,
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

  Future<bool> setIndigency(
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
          "completeName": data['completeName'],
          "firstName": data['firstName'],
          "lastName": data['lastName'],
          "middleInitial": data['middleInitial'],
          "suffixName": data['suffixName'],
          "bgyClearanceCounter": 1,
          "lengthOfStay": data['lengthOfStay'],
          "dateOfAppointment": DateFormat('yyy-M-d').format(DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day)),
          "appointmentOwner": userId,
          "purpose": purpose,
          "status": "Processing",
          "address": data['completeAddress'],
          "age": data['age'],
          "createdAt": DateFormat("yyyy-M-d").format(
            DateTime(
              currentTime.year,
              currentTime.month,
              currentTime.day,
              // currentTime.hour,
              // currentTime.minute,
              // currentTime.second,
            ),
          )
        };
        firestoreDB
            .collection("barangayIndigency")
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
      File complaintImageVideoFile,
      String selectedComplaint,
      String defendantName,
      String defendantLocation,
      String location,
      String contactNumber,
      ) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    bool returnFlag = false;
    DateTime currentTime = DateTime.now();
    int epochTime = currentTime.millisecondsSinceEpoch;
    final docRef = firestoreDB.collection("votersList").doc(userId);

    try {
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          final extension = path.extension(complaintImageVideoFile.path);
          final storageRef = FirebaseStorage.instance.ref().child('complaint_media/$userId/$epochTime$extension');
          await storageRef.putFile(complaintImageVideoFile);
          final complaintMediaUrl = await storageRef.getDownloadURL();

          data['complaintMediaUrl'] = complaintMediaUrl;
          final certificateDetails = <String, dynamic>{
            "completeName": data['completeName'],
            "complaintMediaUrl": data['complaintMediaUrl'],
            "lengthOfStay": data['lengthOfStay'],
            "dateOfAppointment": DateFormat('yyy-M-d').format(DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day)),
            "appointmentOwner": userId,
            "complaint": complaint,
            "address": data['completeAddress'],
            "createdAt": DateFormat("MMMM d, yyy 'at h:mm:ss a UTC+8").format(DateTime(currentTime.year, currentTime.month, currentTime.day, currentTime.hour, currentTime.minute, currentTime.second)),
            "age": data['age'],
            "selectedComplaint" : selectedComplaint,
            "defendantName" : defendantName,
            "defendantLocation" : defendantLocation,
            "location" : location,
            "contactNumber" : contactNumber
          };
          await firestoreDB
              .collection("Complaints")
              .doc(epochTime.toString())
              .set(certificateDetails)
              .then((value) => returnFlag = true)
              .catchError((error) => print('error: $error'));
        }
      }
    } catch (e) {
      print("Error getting document: $e");
    }

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
      File? profileImageFile,
      ) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    bool returnFlag = false;
    DateTime currentTime = DateTime.now();
    int epochTime = currentTime.millisecondsSinceEpoch;
    final docRef = firestoreDB.collection("votersList").doc(userId);

    docRef.get().then(
          (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        if (profileImageFile != null) {
          final storageRef = FirebaseStorage.instance.ref().child('id_images/$userId.png');
          await storageRef.putFile(profileImageFile);
          final IDpictureUrl = await storageRef.getDownloadURL();

          data['IDpictureUrl'] = IDpictureUrl;
        }
        final certificateDetails = <String, dynamic>{
          "completeName": data['completeName'],
          "address": data['completeAddress'],
          "lengthOfStay": data['lengthOfStay'],
          "bgyClearanceCounter": 1,
          "dateOfAppointment": DateFormat('yyy-M-d').format(
            DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day),
          ),
          "appointmentOwner": userId,
          "IDpictureUrl": data['IDpictureUrl'],
          "gender": sex,
          "age": age,
          "weight": weight,
          "height": height,
          "status": "Processing",
          "amountPaid": amount,
          "transactionId": transactionID,
          "transactionDate": currentTime.toUtc().toString(),
          "createdAt": DateFormat("yyyy-M-d").format(
            DateTime(
              currentTime.year,
              currentTime.month,
              currentTime.day,
              // currentTime.hour,
              // currentTime.minute,
              // currentTime.second,
            ),
          )
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

  Future<bool> setBrgIDTest(
      String userId,
      dynamic appointmentDate,
      String sex,
      String age,
      String weight,
      String height,
      String amount,
      File? profileImageFile,
      File? signatureImageFile,
      String emergencyContact,
      String emergencyName,
      ) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
    bool returnFlag = false;
    DateTime currentTime = DateTime.now();
    int epochTime = currentTime.millisecondsSinceEpoch;
    final docRef = firestoreDB.collection("votersList").doc(userId);
    print(signatureImageFile);

    docRef.get().then(
          (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        if (profileImageFile != null && signatureImageFile !=null) {
          Reference storageRef =
          FirebaseStorage.instance.ref().child('id_images/$userId.png');
          await storageRef.putFile(profileImageFile);
          final IDpictureUrl = await storageRef.getDownloadURL();

          storageRef = FirebaseStorage.instance.ref().child('id_images/${userId}_signature.png');
          await storageRef.putFile(signatureImageFile);
          final signatureURL = await storageRef.getDownloadURL();


          data['IDpictureUrl'] = IDpictureUrl;
          data['signatureURL'] = signatureURL;

        }else if(signatureImageFile != null){
          data['IDpictureUrl'] = data['profileURL'];
          Reference storageRef = FirebaseStorage.instance.ref().child('id_images/${userId}_signature.png');
          await storageRef.putFile(signatureImageFile);
          final signatureURL = await storageRef.getDownloadURL();
          data['signatureURL'] = signatureURL;
        }else{
          data['IDpictureUrl'] = data['profileURL'];
        }
        final certificateDetails = <String, dynamic>{
          "completeName": data['completeName'],
          "address": data['completeAddress'],
          "lengthOfStay": data['lengthOfStay'],
          "bgyClearanceCounter": 1,
          "dateOfAppointment": DateFormat('yyy-M-d').format(
            DateTime(appointmentDate.year, appointmentDate.month,
                appointmentDate.day),
          ),
          "appointmentOwner": userId,
          "IDpictureUrl": data['IDpictureUrl'],
          "gender": sex,
          "age": age,
          "weight": weight,
          "height": height,
          "status": "Processing",
          'signatureURL': data['signatureURL'],
          "amountPaid": amount,
          "transactionDate": currentTime.toUtc().toString(),
          "emergency_contact": emergencyContact,
          "emergency_name": emergencyName,
          ...data,
          "createdAt": DateFormat("yyyy-M-d").format(
            DateTime(
              currentTime.year,
              currentTime.month,
              currentTime.day,
              // currentTime.hour,
              // currentTime.minute,
              // currentTime.second,
            ),
          )
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


  Future<bool> hasPendingAppointment(String userId, String collectionName) async {
    FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

    if(collectionName != 'Complaints'){
      var querySnapshot = await firestoreDB
          .collection(collectionName)
          .where('appointmentOwner', isEqualTo: userId)
          .where('status', whereIn: ['Processing', 'Ready for pickup'])
          .get();
      return querySnapshot.docs.isNotEmpty;
    } else {var querySnapshot = await firestoreDB
        .collection(collectionName)
        .where('appointmentOwner', isEqualTo: userId)
        .get();

    return querySnapshot.docs.isNotEmpty;
    }
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
