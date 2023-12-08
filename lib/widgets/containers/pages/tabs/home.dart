import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/global/responsive_sizing.dart';
import 'package:barangay_repository_app/widgets/core/core_calendar/core_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  FirebaseQuery firebaseQuery = FirebaseQuery();
  List<dynamic> appointments = [];
  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> fetchAppointments() async {
    var appointment = [];
    try {
      var querySnapshot = await firestoreDB
          .collection("barangayID")
          .where("appointmentOwner", isEqualTo: _auth.currentUser!.uid)
          .get();

      for (var docSnapshot in querySnapshot.docs) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        appointment.add({
          "appointment": data['appointmentDate'],
          "type": "barangayID",
        });

        // appointments.add();
      }
    } catch (e) {
      print("Error completing: $e");
    }
    return appointment;
  }

  @override
  void initState() {
    super.initState();

    fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSizing responsiveSizing = ResponsiveSizing(context);
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveSizing.calc_width(10),
                vertical: responsiveSizing.calc_height(10)),
            child: CoreCalendar()));
  }
}
