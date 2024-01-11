import 'dart:io';
import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/containers/dialog/dialogs.dart';
import 'package:barangay_repository_app/widgets/core/core_dropdown/core_dropdown.dart';
import 'package:barangay_repository_app/widgets/core/core_id_holder/core_id_holder.dart';
import 'package:barangay_repository_app/widgets/core/core_image_video_holder/core_image_video_holder.dart';
import 'package:barangay_repository_app/widgets/core/core_textfield/core_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
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

  final TextEditingController complaintController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedGender = 'Male';

  File? _IdImageFile;
  File? _ComplaintImageVideoFile;

  FirebaseQuery firebaseQuery = FirebaseQuery();

  List<String> dropdownOptions = [
    'Clearance',
    'Certificate',
    'Identification Card',
    'Complaint'
  ];

  List<String> gender = [
    'Male',
    'Female',
  ];

  String selectedOption = '';

  void handleDropdownChange(String newValue) {
    setState(() {
      selectedOption = newValue;
    });
  }

  void handleGenderChange(String newValue) {
    setState(() {
      selectedGender = newValue;
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
      firstDate: DateTime.now(),
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
                 Text(
                  selectedOption != 'Complaint' ?
                  'Book a Appointment' : 'Submit a Complaint',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: selectedOption == 'Complaint',
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CoreImageVideoHolder(
                        onComplaintMediaChanged: (File? imageVideoFile) {
                          if (imageVideoFile != null) {
                            setState(() {
                              _ComplaintImageVideoFile = imageVideoFile;
                            });
                          } else {
                            print('Walang file na upload');
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      const Text(
                        'Upload your proof in Video/Photo',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: selectedOption == 'Identification Card',
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        CoreIdHolder(
                          onIdImageChanged: (File? IdImageFile) {
                            if (IdImageFile != null) {
                              setState(() {
                                _IdImageFile = IdImageFile;
                              });
                            } else {
                              print('Walang file na upload');
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        const Text(
                          'Upload your ID picture (2x2)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height:16),
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
                const SizedBox(height: 10),
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
                Visibility(
                    visible: selectedOption == 'Complaint'
                        ? true
                        : false,
                    child: TextFormField(
                      maxLines: 3,
                      controller: complaintController,
                      decoration: const InputDecoration(
                        labelText: 'Complaint',
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
                        CoreDropdown(
                          labelText: 'Select Gender',
                          options: gender,
                          selectedOption: selectedGender,
                          onChanged: handleGenderChange,
                          enabled: true,
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
                        // ElevatedButton(onPressed: (){
                        //   print("Test");
                        // }, child: const Text('Add Payment'))
                      ],
                    )),
                ElevatedButton(
                  onPressed: () async {
                    // Handle save appointment logic
                    // firebaseQuery.appointOrRequestAppointment(
                    //     {_certificateController.text, _startDate, _endDate},
                    //     _auth.currentUser!.uid);
                    if (selectedOption == 'Certificate') {
                      bool hasPendingAppointments = await firebaseQuery.hasPendingAppointment(_auth.currentUser!.uid, 'barangayCertificate');

                      if (hasPendingAppointments) {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          desc: "You already have a pending appointment for Certificate.",
                          closeFunction: null,
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ).show();
                      } else {
                        bool shouldProceed = await showAppointmentConfirmationDialog(context);

                        if (shouldProceed) {
                          firebaseQuery
                              .setCertificate(_auth.currentUser!.uid, _startDate, purposeController.text)
                              .then((value) {
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
                                  child: const Text('OK'),
                                ),
                              ],
                            ).show();
                          });
                        }
                      }
                    } else if (selectedOption == 'Clearance') {
                      bool hasPendingAppointments = await firebaseQuery.hasPendingAppointment(_auth.currentUser!.uid, 'barangayClearance');

                      if (hasPendingAppointments) {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          desc: "You already have a pending appointment for Clearance.",
                          closeFunction: null,
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ).show();
                      } else {
                        bool shouldProceed = await showAppointmentConfirmationDialog(context);

                        if (shouldProceed) {
                          firebaseQuery
                              .setClearance(_auth.currentUser!.uid, _startDate, purposeController.text)
                              .then((value) {
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
                                  child: const Text('OK'),
                                ),
                              ],
                            ).show();
                          });
                        }
                      }
                    }
                    else if (selectedOption == 'Complaint') {
                      firebaseQuery
                          .setComplaint(_auth.currentUser!.uid, _startDate,
                          complaintController.text, _ComplaintImageVideoFile)
                          .then((value) =>
                      {
                        complaintController.clear(),
                        setState(() {
                          selectedOption = 'Clearance';
                        }),
                        Alert(
                            context: context,
                            type: AlertType.success,
                            desc: "Complaint submitted",
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
                      bool hasPendingAppointments = await firebaseQuery.hasPendingAppointment(_auth.currentUser!.uid, 'barangayID');

                      if (hasPendingAppointments) {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          desc: "You already have a pending appointment for Barangay ID.",
                          closeFunction: null,
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ).show();
                      } else {
                        bool shouldProceed = await showPaypalConfirmationDialog(context);

                        if (shouldProceed) {
                          BuildContext dialogContext = context;
                          Map<String, dynamic>? result = await Navigator.push(
                            dialogContext,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PaypalCheckout(
                                    // sandboxMode: true,
                                      clientId: "AZxYyI4LNE-ZBt6A1GCScu_gXF-XoNbAZTjMj6EpH9SeNsf3TzH2rTdL7esMtmlYWtzJy6Ollbc8Rme0",
                                      secretKey: "EISZmF-_bpCXTKC6vEk9aE9b4ZXJb86Oyz1Mys7wc-Lbcz-9GKIRLzDZSguW4bWwQmeLLqpxcJJOVsuY",
                                      returnURL: "success.snippetcoder.com",
                                      //Pwede to palitan base sa preference nyo
                                      cancelURL: "cancel.snippetcoder.com",
                                      //Pwede to palitan base sa preference nyo
                                      transactions: const [
                                        {
                                          "amount": {
                                            "total": '0.01',
                                            "currency": "PHP",
                                            "details": {
                                              "subtotal": '0.01',
                                            }
                                          },
                                          "description":
                                          "Your Barangay ID order description.",
                                          "item_list": {
                                            "items": [
                                              {
                                                "name": "Barangay ID",
                                                "quantity": 1,
                                                "price": '0.01',
                                                "currency": "PHP"
                                              }
                                            ],
                                          }
                                        }
                                      ],
                                      note: "Contact us for any questions on your order.",
                                      onSuccess: (Map params) async {
                                        // print("onSuccess: $params"); Uncomment if want nyo maprint ang whole transaction details:>

                                        String transactionId = (params['data'] !=
                                            null &&
                                            params['data']['id'] != null)
                                            ? params['data']['id']
                                            : '';

                                        await firebaseQuery.setBrgID(
                                          _auth.currentUser!.uid,
                                          _startDate,
                                          selectedGender,
                                          _age.text,
                                          _weight.text,
                                          _height.text,
                                          '100.00',
                                          transactionId,
                                          _IdImageFile,
                                        );
                                        showTransactionReceipt(context, transactionId);
                                        selectedGender = 'Male';
                                        _age.clear();
                                        _weight.clear();
                                        _height.clear();
                                      },
                                      onError: (error) {
                                        print("onError: $error");
                                      },
                                      onCancel: () {
                                        print('Transaction cancelled');
                                    }
                                 ),
                              ),
                            ); // **Warning lang yan**
                          }
                        }
                      };
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text(
                    selectedOption == 'Identification Card'
                        ? 'Proceed to Payment'
                        : selectedOption == 'Complaint' ?
                        'Submit Complaint' : 'Make Appointment',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
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
