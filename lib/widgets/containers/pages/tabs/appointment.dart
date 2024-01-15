import 'dart:io';
import 'package:barangay_repository_app/firebase_query.dart';
import 'package:barangay_repository_app/widgets/containers/dialog/dialogs.dart';
import 'package:barangay_repository_app/widgets/core/core_dropdown/core_dropdown.dart';
import 'package:barangay_repository_app/widgets/core/core_id_holder/core_id_holder.dart';
import 'package:barangay_repository_app/widgets/core/core_textfield/core_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:barangay_repository_app/widgets/core/core_image_video_holder/core_image_video_holder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:barangay_repository_app/constants/colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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

  final TextEditingController _NameEmCon = TextEditingController();

  final TextEditingController _EmCon = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController purposeController = TextEditingController();

  late TextEditingController complaintController = TextEditingController();

  late TextEditingController quantityController = TextEditingController();

  late TextEditingController defendantNameController = TextEditingController();

  late TextEditingController defendantLocationController = TextEditingController();

  late TextEditingController locationController = TextEditingController();

  late TextEditingController contactNumberController = TextEditingController();

  void clearInputs() {
    _certificateController.text = '';
    _sex.text = '';
    _age.text = '';
    _weight.text = '';
    _height.text = '';
    purposeController.text = '';
    complaintController.text = '';
    _NameEmCon.text = '';
    _EmCon.text = '';
    quantityController.text = '1';
    defendantNameController.text = '';
    defendantLocationController.text = '';
    locationController.text = '';
    contactNumberController.text = '';
    _IdImageFile = null;
    _SignatureImageFile = null;
    _ComplaintImageVideoFile = null;
    displayFile = null;
    _sign.currentState?.clear();
    setState(() {});
  }

  String selectedComplaint = 'Person';
  String selectedGender = 'Male';

  File? _IdImageFile;
  File? _ComplaintImageVideoFile;
  File? _SignatureImageFile;

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

  List<String> purposeOptions = [
    'Loan',
    'Bank requirement',
    'Local employment',
    'Maynilad requirement',
    'Philhealth requirement',
    'Proof of residency',
    'Transfer of place',
    'School',
    'Financial assistant',
    'Medical assisstant',
    'Scholarship requirement',
    'NBI',
    'Police clearance',
    'Bail',
    'Solo parent',
    'Fact of birth',
    'Late for registration',
    'Not PUI/PUM for COVID',
  ];


  List<String> complaintOptions = [
    'Person',
    'General (Other Complaint)'
  ];

  String selectedOption = '';
  String selectedPurpose = 'Loan';

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

  void handleSelectedComplaint(String newValue) {
    setState(() {
      selectedComplaint = newValue;
    });
  }

  // PlatformFile? pickedFile;
  File? displayFile;
  bool? isLoading;

  final _sign = GlobalKey<SignatureState>();

  Future<File> saveImageToFile(ByteData byteData) async {
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'signature_image.png';
    final file = File('${appDir.path}/$fileName');

    File result = await file.writeAsBytes(pngBytes);
    return result;
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                          'Upload your Evidence in Video/Photo',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height:16),
                  Visibility(
                    visible: selectedOption == 'Identification Card',
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 350,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: SizedBox(
                            width: 350,
                            height: 200,
                            child: Signature(
                              color: Colors.black, // Color of the drawing path
                              strokeWidth: 5.0, // with
                              key: _sign,
                            ),
                          ),
                        ),
                        const Text(
                          'Put your signature here',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CoreDropdown(
                          labelText: 'Select an option',
                          options: dropdownOptions,
                          selectedOption: selectedOption,
                          onChanged: handleDropdownChange,
                          enabled: true,
                        ),
                      ),
                      Visibility(
                        visible: selectedOption == 'Clearance' ||
                            selectedOption == 'Certificate'
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            width: 100,
                            height: 47,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              controller: quantityController = TextEditingController(text: '1'),
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          CoreDropdown(
                            labelText: 'Complaint',
                            options: complaintOptions,
                            selectedOption: selectedComplaint,
                            onChanged: handleSelectedComplaint,
                            enabled: true,
                          ),
                          const SizedBox(height: 16),
                          Visibility(
                              visible: selectedComplaint == 'Person'
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: defendantNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Name of Defendant',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: defendantLocationController,
                                      decoration: const InputDecoration(
                                        labelText: 'Location of Defendant',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              )
                          ),
                          Visibility(
                              visible: selectedComplaint == 'General (Other Complaint)'
                                  ? true
                                  : false,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: locationController,
                                      decoration: const InputDecoration(
                                        labelText: 'Location',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              )
                          ),
                          // ElevatedButton(
                          //   onPressed: (){
                          //     selectFile();
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: AppColors.primaryColor,
                          //   ),
                          //   child: const Text('Evidence (Upload Photo/Video)',
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          // if(pickedFile != null)
                          //   SizedBox(
                          //     child: Image.file(displayFile!),
                          //   ),
                          SizedBox(
                              height: 100,
                              child: IntlPhoneField(
                                initialCountryCode: 'PH',
                                keyboardType: TextInputType.phone,
                                controller: contactNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Your contact number',
                                  border: OutlineInputBorder(),
                                ),
                              )
                          ),
                          TextFormField(
                            maxLines: 3,
                            controller: complaintController,
                            decoration: const InputDecoration(
                              labelText: 'Complaint',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
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
                          CoreTextfield(
                            labelText: 'Name Of Emergency Contact',
                            controller: _NameEmCon,
                          ),
                          const SizedBox(height: 16),
                          CoreTextfield(
                            labelText: 'Contact Number',
                            controller: _EmCon,
                          ),
                          const SizedBox(height: 16),
                          // ElevatedButton(onPressed: (){
                          //   print("Test");
                          // }, child: const Text('Add Payment'))
                        ],
                      )),
                  ElevatedButton(
                    onPressed: submitAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text(
                      selectedOption == 'Identification Card'
                          ? 'Proceed to Payment'
                          : (selectedOption == 'Complaint' ? 'Submit Complaint' : 'Make Appointment'),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                  ],
              ),
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

  void submitCertificate() async {
    bool hasPendingAppointments = await firebaseQuery.hasPendingAppointment(
        _auth.currentUser!.uid, 'barangayCertificate');

    if (hasPendingAppointments) {
      Alert(
        context: context,
        type: AlertType.warning,
        desc: "You already have a pending appointment for Certificate.",
        closeFunction: null,
        buttons: [
          DialogButton(
            onPressed: () {
              clearInputs();
              purposeController.text = '';
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
            .setCertificate(_auth.currentUser!.uid, _startDate, selectedPurpose, quantityController.text)
            .then((value) {
          Alert(
            context: context,
            type: AlertType.success,
            desc: "Appointment success",
            closeFunction: null,
            buttons: [
              DialogButton(
                onPressed: (() {
                  clearInputs();
                  purposeController.text = '';
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

  void submitClearance() async {
    bool hasPendingAppointments = await firebaseQuery.hasPendingAppointment(
        _auth.currentUser!.uid, 'barangayClearance');

    if (hasPendingAppointments) {
      Alert(
        context: context,
        type: AlertType.warning,
        desc: "You already have a pending appointment for Clearance.",
        closeFunction: null,
        buttons: [
          DialogButton(
            onPressed: () {
              clearInputs();
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
            .setClearance(_auth.currentUser!.uid, _startDate, selectedPurpose, quantityController.text)
            .then((value) {
          Alert(
            context: context,
            type: AlertType.success,
            desc: "Appointment success",
            closeFunction: null,
            buttons: [
              DialogButton(
                onPressed: (() {
                  clearInputs();
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

  void submitIndigency() async {
    bool hasPendingAppointments = await firebaseQuery.hasPendingAppointment(_auth.currentUser!.uid, 'barangayIndigency');

    if (hasPendingAppointments) {
      Alert(
        context: context,
        type: AlertType.warning,
        desc: "You already have a pending appointment for Indigency.",
        closeFunction: null,
        buttons: [
          DialogButton(
            onPressed: () {
              clearInputs();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ).show();
    } else {
      bool shouldProceed = await showAppointmentConfirmationDialog(context);

      if (shouldProceed) {
        firebaseQuery.setIndigency(_auth.currentUser!.uid, _startDate, selectedPurpose).then((value) {
          Alert(
            context: context,
            type: AlertType.success,
            desc: "Appointment success",
            closeFunction: null,
            buttons: [
              DialogButton(
                onPressed: (() {
                  clearInputs();
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

  void submitComplaint() async {
    if (selectedComplaint == "Person") {
      if (defendantNameController.text == '') {
        Alert(
          context: context,
          type: AlertType.error,
          desc: "Defendant name must not be empty",
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
        return;
      }
      if (defendantLocationController.text == '') {
        Alert(
          context: context,
          type: AlertType.error,
          desc: "Location of incident must not be empty",
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
        return;
      }
    } else {
      if (locationController.text.isEmpty) {
        Alert(
          context: context,
          type: AlertType.error,
          desc: "Location must not be empty",
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
        return;
      }
    }
    if (_ComplaintImageVideoFile == null) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Evidence is required",
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
      return;
    }
    if (contactNumberController.text.isEmpty) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Contact number must not be empty",
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
      return;
    }
    if (complaintController.text.isEmpty) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Complaint must not be empty",
        closeFunction: null,
        buttons: [
          DialogButton(
            onPressed: () {
              clearInputs();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ).show();
      return;
    }
    bool shouldProceed = await showAppointmentConfirmationDialog(context);

    if (shouldProceed) {
      firebaseQuery
          .setComplaint(
          _auth.currentUser!.uid,
          _startDate,
          complaintController.text,
          _ComplaintImageVideoFile!,
          selectedComplaint,
          defendantNameController.text,
          defendantLocationController.text,
          locationController.text,
          contactNumberController.text,)
          .then((value) => {
        Alert(
            context: context,
            type: AlertType.success,
            desc: "Appointment success",
            closeFunction: null,
            buttons: [
              DialogButton(
                  onPressed: (() {
                    clearInputs();
                    Navigator.pop(context);
                  }),
                  child: const Text('OK'))
            ]).show()
      });
    }
  }

  void submitID() async {
    if (_weight.text.isEmpty) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Weight must not be empty",
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
      return;
    }
    if (_height.text.isEmpty) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Height must not be empty",
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
      return;
    }
    if (_NameEmCon.text.isEmpty) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Name of Emergency Contact must not be empty",
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
      return;
    }
    if (_EmCon.text.isEmpty) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Contact Number must not be empty",
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
      return;
    }
    if (_IdImageFile == null) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "ID image is required",
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
      return;
    }
    if (!_sign.currentState!.hasPoints) {
      Alert(
        context: context,
        type: AlertType.error,
        desc: "Signature is required",
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
      return;
    }

    bool hasPendingAppointments = await firebaseQuery.hasPendingAppointment(
        _auth.currentUser!.uid, 'barangayID');

    if (hasPendingAppointments) {
      Alert(
        context: context,
        type: AlertType.warning,
        desc: "You already have a pending appointment for Barangay ID.",
        closeFunction: null,
        buttons: [
          DialogButton(
            onPressed: () {
              clearInputs();
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
            builder: (BuildContext context) => PaypalCheckout(
              // sandboxMode: true,
                clientId:
                "AZxYyI4LNE-ZBt6A1GCScu_gXF-XoNbAZTjMj6EpH9SeNsf3TzH2rTdL7esMtmlYWtzJy6Ollbc8Rme0",
                secretKey:
                "EISZmF-_bpCXTKC6vEk9aE9b4ZXJb86Oyz1Mys7wc-Lbcz-9GKIRLzDZSguW4bWwQmeLLqpxcJJOVsuY",
                returnURL: "success.snippetcoder.com",
                //Pwede to palitan base sa preference nyo
                cancelURL: "cancel.snippetcoder.com",
                //Pwede to palitan base sa preference nyo
                transactions: const [
                  {
                    "amount": {
                      "total": '100.00',
                      "currency": "PHP",
                      "details": {
                        "subtotal": '100.00',
                      }
                    },
                    "description": "Your Barangay ID order description.",
                    "item_list": {
                      "items": [
                        {
                          "name": "Barangay ID",
                          "quantity": 1,
                          "price": '100.00',
                          "currency": "PHP"
                        }
                      ],
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  // print("onSuccess: $params"); Uncomment if want nyo maprint ang whole transaction details:>

                  String transactionId =
                  (params['data'] != null && params['data']['id'] != null)
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
                }),
          ),
        ); // **Warning lang yan**
      } else {
        _sign.currentState?.getData().then((signature) async {
          signature.toByteData(format: ui.ImageByteFormat.png).then((data) {
            if (data != null) {
              saveImageToFile(data).then((file) async {
                _SignatureImageFile = file;
                await firebaseQuery.setBrgIDTest(
                  _auth.currentUser!.uid,
                  _startDate,
                  selectedGender,
                  _age.text,
                  _weight.text,
                  _height.text,
                  '100.00',
                  _IdImageFile,
                  _SignatureImageFile,
                  _EmCon.text,
                  _NameEmCon.text,
                );
              });
              Alert(
                  context: context,
                  type: AlertType.success,
                  desc: "Appointment success",
                  closeFunction: null,
                  buttons: [
                    DialogButton(
                        onPressed: (() {
                          clearInputs();
                          Navigator.pop(context);
                        }),
                        child: const Text('OK'))
                  ]).show();
            } else {
              print('byte data is missing');
            }
          });
        });
      }
    }
  }

  void submitAppointment() async {
    if (selectedOption == 'Certificate') {
      submitCertificate();
    } else if (selectedOption == 'Clearance') {
      submitClearance();
    } else if (selectedOption == 'Indigency') {
      submitIndigency();
    } else if (selectedOption == 'Complaint') {
      submitComplaint();
    } else {
      submitID();
    }
  }
}
