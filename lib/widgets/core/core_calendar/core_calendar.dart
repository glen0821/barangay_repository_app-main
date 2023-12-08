import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/global/responsive_sizing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:barangay_repository_app/constants/colors.dart';

class CoreCalendar extends StatefulWidget {
  const CoreCalendar({
    super.key,
  });

  @override
  State<CoreCalendar> createState() => _CoreCalendarState();
}

class _CoreCalendarState extends State<CoreCalendar> {
  int _currentSelection = 0;
  CalendarView calendarView = CalendarView.month;
  CalendarController _calendarController = CalendarController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  FirebaseQuery firebaseQuery = FirebaseQuery();

  final Map<int, Widget> _children = {
    0: const Text(
      'Month',
    ),
    1: const Text('Week'),
    2: const Text('Day'),
  };

  List<Meeting> sources = [];
  Future<List<Meeting>> _getDataSource() async {
    final List<Meeting> meetings = <Meeting>[];
    var querySnapshot = await firestoreDB
        .collection("barangayID")
        .where("appointmentOwner", isEqualTo: _auth.currentUser!.uid)
        .get();
    var querySnapshot2 = await firestoreDB
        .collection("barangayCertificate")
        .where("appointmentOwner", isEqualTo: _auth.currentUser!.uid)
        .get();
    var querySnapshot3 = await firestoreDB
        .collection("barangayClearance")
        .where("appointmentOwner", isEqualTo: _auth.currentUser!.uid)
        .get();

    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      final DateTime today = DateTime.now();
      Timestamp ts = data['appointmentDate'];
      DateTime dt = ts.toDate();
      final DateTime startTime = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 2));

      meetings.add(Meeting('Barangay ID', startTime, endTime));
    }
    for (var docSnapshot2 in querySnapshot2.docs) {
      final data = docSnapshot2.data() as Map<String, dynamic>;
      final DateTime today = DateTime.now();
      Timestamp ts = data['appointmentDate'];
      DateTime dt = ts.toDate();
      final DateTime startTime = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 2));

      meetings.add(Meeting('Barangay Certificate', startTime, endTime));
    }
    for (var docSnapshot3 in querySnapshot3.docs) {
      final data = docSnapshot3.data() as Map<String, dynamic>;
      final DateTime today = DateTime.now();
      Timestamp ts = data['appointmentDate'];
      DateTime dt = ts.toDate();
      final DateTime startTime = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 2));

      meetings.add(Meeting('Barangay Clearance', startTime, endTime));
    }

    return meetings;
  }

  @override
  void initState() {
    super.initState();
    _getDataSource().then((value) => sources = value);
    print('sources: ');
    print(sources);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: MaterialSegmentedControl(
              children: _children,
              selectionIndex: _currentSelection,
              borderColor: AppColors.primaryColor,
              selectedColor: Colors.white70,
              unselectedColor: AppColors.primaryColor,
              borderRadius: 5.0,
              disabledChildren: const [3],
              onSegmentTapped: (index) {
                setState(() {
                  _currentSelection = index;
                  switch (index) {
                    case 0:
                      calendarView = CalendarView.month;
                      break;
                    case 1:
                      calendarView = CalendarView.week;
                      break;
                    case 2:
                      calendarView = CalendarView.day;
                      break;
                    default:
                  }

                  _calendarController.view = calendarView;
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: SfCalendar(
            controller: _calendarController,
            headerStyle: const CalendarHeaderStyle(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            view: calendarView,
            dataSource: MeetingDataSource(sources),
            // ...
          ),
        ),
      ],
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;
}
