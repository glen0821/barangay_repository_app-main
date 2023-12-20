  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:syncfusion_flutter_calendar/calendar.dart';
  import 'package:material_segmented_control/material_segmented_control.dart';
  import 'package:barangay_repository_app/widgets/containers/dialog/dialogs.dart';

  import '../../../constants/colors.dart';

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

    final Map<int, Widget> _children = {
      0: const Text('Month',),
      1: const Text('Week'),
      2: const Text('Day'),
    };

    double _fontSize(CalendarView view) {
      switch (view) {
        case CalendarView.month:
          return 8.0;
        case CalendarView.week:
          return 12.0;
        case CalendarView.day:
          return 16.0;
        default:
          return 12.0;
      }
    }

    List<Meeting> sources = [];

    Future<List<Meeting>> _getDataSource() async {
      final List<Meeting> meetings = <Meeting>[];

      meetings.clear();

      // taga fetch meetings sa barangayID collection
      await _fetchMeetings('barangayID', meetings);

      // taga fetch meetings sa barangayCertificate collection
      await _fetchMeetings('barangayCertificate', meetings);

      // taga fetch meetings sa barangayClearance collection
      await _fetchMeetings('barangayClearance', meetings);

      return meetings;
    }

    Future<void> _fetchMeetings(String collectionName, List<Meeting> meetings) async {
      var querySnapshot = await firestoreDB
          .collection(collectionName)
          .where("appointmentOwner", isEqualTo: _auth.currentUser!.uid)
          .where("status", whereIn: ['Processing', 'Ready for pickup'])
          .get();

      for (var docSnapshot in querySnapshot.docs) {
        final data = docSnapshot.data();
        final DateTime today = DateTime.now();
        Timestamp ts = Timestamp.fromDate(DateTime.parse(data['dateOfAppointment']));
        DateTime dt = ts.toDate();
        final DateTime startTime = DateTime(dt.year, dt.month, dt.day, 9, 0, 0);
        final DateTime endTime = startTime.add(const Duration(hours: 2));

        String meetingName = '';
        String status = data['status'] ?? '';
        if (collectionName == 'barangayID') {
          meetingName = 'Barangay ID';
        } else if (collectionName == 'barangayCertificate') {
          meetingName = 'Certificate';
        } else if (collectionName == 'barangayClearance') {
          meetingName = 'Clearance';
        }
        String documentId = docSnapshot.id;
        meetings.add(Meeting(meetingName, startTime, endTime, status, collectionName, documentId));
      }
    }



    @override
    void initState() {
      super.initState();
      _getDataSource().then((value) {
        setState(() {
          sources = value;
        });
        // for (Meeting meeting in sources) {
        //   print('Meeting Name: ${meeting.eventName}');
        //   print('Meeting Name: ${meeting.documentId}');
        //   print('Meeting status: ${meeting.status}');
        //   print('Start Time: ${meeting.from}');
        //   print('End Time: ${meeting.to}');
        //   print('-----------------------');
        // }
      });
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
              appointmentTextStyle: TextStyle(
                fontSize: _fontSize(calendarView),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
                String meetingName = '';
                String collectionName = '';
                String docuID = '';
                String status = '';
                if (details.appointments.isNotEmpty && details.appointments.first is Meeting) {
                  meetingName = (details.appointments.first as Meeting).eventName;
                  status = (details.appointments.first as Meeting).status;
                  collectionName = (details.appointments.first as Meeting).collectionName;
                  docuID = (details.appointments.first as Meeting).documentId;
                }
                return Container(
                  color: AppColors.primaryColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          meetingName,
                          style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              fontSize: _fontSize(calendarView)
                          ),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            color: status == 'Processing' ? Colors.red : Colors.limeAccent,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontSize: _fontSize(calendarView),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
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
      final Meeting meetingData = _getMeetingData(index);
      return '${meetingData.eventName} - ${meetingData.status}';
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
    Meeting(this.eventName, this.from, this.to, this.status, this.collectionName, this.documentId);

    /// Event name which is equivalent to the subject property of [Appointment].
    String eventName;

    /// From which is equivalent to the start time property of [Appointment].
    DateTime from;

    /// To which is equivalent to the end time property of [Appointment].
    DateTime to;

    /// Status of the meeting.
    String status;

    /// Firestore collection name.
    String collectionName;

    /// Firestore document ID.
    String documentId;
  }
