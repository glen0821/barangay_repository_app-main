import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/core/core_dropdown/core_dropdown.dart';
import 'package:barangay_repository_app/widgets/core/core_textfield/core_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:barangay_repository_app/constants/colors.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int _selectedPriority = 1;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final TextEditingController _certificateController = TextEditingController();

  final TextEditingController _sex = TextEditingController();

  final TextEditingController _age = TextEditingController();

  final TextEditingController _weight = TextEditingController();

  final TextEditingController _height = TextEditingController();

  final TextEditingController purposeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseQuery firebaseQuery = FirebaseQuery();

  List<String> dropdownOptions = [
    'Clearance',
    'Certificate',
    'Identification Card'
  ];
  String selectedOption = '';

  void handleDropdownChange(String newValue) {
    setState(() {
      selectedOption = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedOption = dropdownOptions[0];
    // firebaseQuery.
  }
  // Future<void> _selectStartDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: _startDate,
  //     firstDate: DateTime(2022),
  //     lastDate: DateTime(2025),
  //   );

  //   if (pickedDate != null && pickedDate != _startDate) {
  //     setState(() {
  //       _startDate = pickedDate;
  //     });
  //   }
  // }

  Future<void> _selectAppointmentDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }
  // Future<void> _selectEndDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: _endDate,
  //     firstDate: _startDate,
  //     lastDate: DateTime(2025),
  //   );

  //   if (pickedDate != null && pickedDate != _endDate) {
  //     setState(() {
  //       _endDate = pickedDate;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Appointment Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CoreDropdown(
                  labelText: 'Select an option',
                  options: dropdownOptions,
                  selectedOption: selectedOption,
                  onChanged: handleDropdownChange,
                  enabled: true,
                ),
                // TextFormField(
                //   controller: _certificateController,
                //   decoration: const InputDecoration(
                //     labelText: 'Certificate/Appointment',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                const SizedBox(height: 16),
                Visibility(
                    visible: selectedOption == 'Clearance' ||
                            selectedOption == 'Certificate'
                        ? true
                        : false,
                    child: TextFormField(
                      maxLines: 3,
                      controller: purposeController,
                      decoration: const InputDecoration(
                        labelText: 'Purpose',
                        border: OutlineInputBorder(),
                      ),
                    )),
                const SizedBox(height: 16),
                // const Text(
                //   'Priority',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 16),
                // Wrap(
                //   spacing: 8.0,
                //   children: [
                //     _buildPriorityButton(1, Icons.low_priority),
                //     _buildPriorityButton(2, Icons.priority_high),
                //     _buildPriorityButton(3, Icons.block),
                //   ],
                // ),
                // const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectAppointmentDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Select appointment date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Visibility(
                    visible:
                        selectedOption == 'Identification Card' ? true : false,
                    child: Column(
                      children: [
                        CoreTextfield(
                          labelText: 'Sex',
                          controller: _sex,
                        ),
                        const SizedBox(height: 16),
                        CoreTextfield(
                          labelText: 'Age',
                          controller: _age,
                        ),
                        const SizedBox(height: 16),
                        CoreTextfield(
                          labelText: 'Weight (kg)',
                          controller: _weight,
                        ),
                        const SizedBox(height: 16),
                        CoreTextfield(
                          labelText: 'Height (cm)',
                          controller: _height,
                        ),
                        const SizedBox(height: 16),
                      ],
                    )),
                ElevatedButton(
                  onPressed: () {
                    // Handle save appointment logic
                    // firebaseQuery.appointOrRequestAppointment(
                    //     {_certificateController.text, _startDate, _endDate},
                    //     _auth.currentUser!.uid);
                    if (selectedOption == 'Certificate') {
                      // print(_auth.currentUser);
                      firebaseQuery
                          .setCertificate(_auth.currentUser!.uid, _startDate,
                              purposeController.text)
                          .then((value) => {
                                Alert(
                                    context: context,
                                    type: AlertType.success,
                                    desc: "Appointment success",
                                    closeFunction: null,
                                    buttons: [
                                      DialogButton(
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          child: const Text('OK'))
                                    ]).show()
                              });
                    } else if (selectedOption == 'Clearance') {
                      firebaseQuery
                          .setClearance(_auth.currentUser!.uid, _startDate,
                              purposeController.text)
                          .then((value) => {
                                Alert(
                                    context: context,
                                    type: AlertType.success,
                                    desc: "Appointment success",
                                    closeFunction: null,
                                    buttons: [
                                      DialogButton(
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          child: const Text('OK'))
                                    ]).show()
                              });
                    } else {
                      firebaseQuery
                          .setBrgID(_auth.currentUser!.uid, _startDate,
                              _sex.text, _age.text, _weight.text, _height.text)
                          .then((value) => {
                                // print(value.toString())
                                Alert(
                                    context: context,
                                    type: AlertType.success,
                                    desc: "Appointment success",
                                    closeFunction: null,
                                    buttons: [
                                      DialogButton(
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          child: const Text('OK'))
                                    ]).show()
                              });
                    }
                  },
                  child: const Text('Save Appointment'),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(int priority, IconData iconData) {
    return ChoiceChip(
      label: Icon(iconData),
      selected: _selectedPriority == priority,
      onSelected: (bool selected) {
        setState(() {
          _selectedPriority = selected ? priority : 1;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _age.dispose();
    _weight.dispose();
    _sex.dispose();
  }
}
